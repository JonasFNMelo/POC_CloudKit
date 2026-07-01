//
//  ContentViewModel.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import Foundation
import CloudKit

@Observable
class ContentViewModel {

    func saveUser(pUser: PrivateUser) async {
        if await CloudKitService.shared.isUserSaved() {
            print("User ja salvo")
            return
        }
        let privateUserRecord = CKRecord(recordType: RecordType.privateUser.rawValue)
        privateUserRecord.setValuesForKeys(pUser.toDictionary())
        
        let publicUser = User(id: pUser.id, name: pUser.name, imageData: pUser.imageData)
        let publicUserRecord = CKRecord(recordType: RecordType.user.rawValue)
        publicUserRecord.setValuesForKeys(publicUser.toDictionary())
        
        await CloudKitService.shared.savePrivateRecord(record: privateUserRecord)
        await CloudKitService.shared.savePublicRecord(record: publicUserRecord)
    }
    
    func fetchAllPosts() async -> [Post] {
        var posts: [Post] = []
        if let postRecords = await CloudKitService.shared.fetchAllPublicRecords(recordType: RecordType(rawValue: RecordType.post.rawValue)!){
            for pR in postRecords {
                posts.append(Post.fromRecord(record: pR)!)
            }
        }
        print(posts)
        return posts
    }
    
    func fetchAllPostsWithAuthor() async -> [PostWithUser] {
        guard let postRecords = await CloudKitService.shared.fetchAllPublicRecords(recordType: .post) else { return [] }
        
        var result: [PostWithUser] = []
        
        for postRecord in postRecords {
            guard let post = Post.fromRecord(record: postRecord) else { continue }
            
            var user: User? = nil
            if let userID = post.userID,
               let userRecord = await CloudKitService.shared.fetchPublicUser(recordID: userID.recordID) {
                user = User.fromRecord(record: userRecord)
            }
            result.append(PostWithUser(id: post.id, post: post, user: user!))
        }
        return result
    }
}
