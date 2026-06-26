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
    private var ckService: CloudKitService
    
    init(container: CKContainer) {
        self.ckService = CloudKitService(container: container)
    }
    
    private func saveUser(pUser: PrivateUser) async {
        let privateUserRecord = CKRecord(recordType: RecordType.privateUser.rawValue)
        privateUserRecord.setValuesForKeys(pUser.toDictionary())
        
        let publicUser = User(id: pUser.id, name: pUser.name, imageData: pUser.imageData)
        let publicUserRecord = CKRecord(recordType: RecordType.user.rawValue)
        publicUserRecord.setValuesForKeys(publicUser.toDictionary())
        
        await ckService.savePrivateRecord(record: privateUserRecord)
        await ckService.savePublicRecord(record: publicUserRecord)
    }
    
    func savePost(post: Post) async {
        let postRecord = CKRecord(recordType: RecordType.post.rawValue)
        postRecord.setValuesForKeys(post.toDictionary())
        
        switch post.isPrivate {
        case true:
            await ckService.savePrivateRecord(record: postRecord)
        case false:
            await ckService.savePublicRecord(record: postRecord)
        }
    }
    
    func fetchAllPosts() async -> [Post] {
        var posts: [Post] = []
        if let postRecords = await ckService.fetchAllPublicRecords(recordType: RecordType(rawValue: RecordType.post.rawValue)!){
            for pR in postRecords {
                posts.append(Post.fromRecord(record: pR)!)
            }
        }
        return posts
    }
}
