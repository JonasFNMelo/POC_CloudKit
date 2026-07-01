//
//  CreatPostSheetViewModel.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 27/06/26.
//

import Foundation
import PhotosUI
import CloudKit

class CreatPostSheetViewModel {
    
    func savePost(post: Post) async {
        guard let userRecord = await getPublicUser() else {
            print("User público não encontrado")
            return
        }

        let postRecord = CKRecord(recordType: RecordType.post.rawValue)
        let userID = CKRecord.Reference(recordID: userRecord.recordID, action: .deleteSelf)
        var updatedPost = post
        updatedPost.userID = userID
        postRecord.setValuesForKeys(updatedPost.toDictionary())

        switch post.isPrivate {
        case true:
            await CloudKitService.shared.savePrivateRecord(record: postRecord)
        case false:
            await CloudKitService.shared.savePublicRecord(record: postRecord)
        }
        
        var currentPostRefs = userRecord.value(forKey: "postRefs") as? [CKRecord.Reference] ?? []
        currentPostRefs.append(CKRecord.Reference(recordID: postRecord.recordID, action: .none))
        userRecord["postRefs"] = currentPostRefs
        await CloudKitService.shared.savePublicRecord(record: userRecord)
    }
    
    func getPublicUser() async -> CKRecord? {
        guard let privateRecord = await CloudKitService.shared.fetchPrivateUser(),
              let privateUser = PrivateUser.fromRecord(record: privateRecord)
        else {
            return nil
        }
        return await CloudKitService.shared.fetchPublicUser(id: privateUser.id)
    }
}
