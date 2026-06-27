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
        let privateUserRecord = CKRecord(recordType: RecordType.privateUser.rawValue)
        privateUserRecord.setValuesForKeys(pUser.toDictionary())
        
        let publicUser = User(id: pUser.id, name: pUser.name, imageData: pUser.imageData)
        let publicUserRecord = CKRecord(recordType: RecordType.user.rawValue)
        publicUserRecord.setValuesForKeys(publicUser.toDictionary())
        
        await CloudKitService.shared.savePrivateRecord(record: privateUserRecord)
        await CloudKitService.shared.savePublicRecord(record: publicUserRecord)
    }
    
    func savePost(post: Post) async {
        guard let userRecord = await getPublicUser() else {
            print("User público não encontrado")
            return
        }

        let postRecord = CKRecord(recordType: RecordType.post.rawValue)
        let authorRef  = CKRecord.Reference(recordID: userRecord.recordID, action: .deleteSelf)
        var updatedPost = post
        updatedPost.authorRef = authorRef
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
    
    func fetchAllPosts() async -> [Post] {
        var posts: [Post] = []
        if let postRecords = await CloudKitService.shared.fetchAllPublicRecords(recordType: RecordType(rawValue: RecordType.post.rawValue)!){
            for pR in postRecords {
                posts.append(Post.fromRecord(record: pR)!)
            }
        }
        return posts
    }
    
    func getPublicUser() async -> CKRecord? {
        guard let privateRecord = await CloudKitService.shared.fetchPrivateUser(),
              let privateUser = PrivateUser.fromRecord(record: privateRecord)
        else {
            return nil
        }
        return await CloudKitService.shared.fetchPublicUser(id: privateUser.id)
    }
    
    func fetchAllPostsWithAuthor() async -> [PostWithAuthor] {
        guard let postRecords = await CloudKitService.shared.fetchAllPublicRecords(recordType: .post) else { return [] }
        
        var result: [PostWithAuthor] = []
        
        for postRecord in postRecords {
            guard let post = Post.fromRecord(record: postRecord) else { continue }
            
            var author: User? = nil
            if let authorRef = post.authorRef,
               let userRecord = await CloudKitService.shared.fetchPublicUser(recordID: authorRef.recordID) {
                author = User.fromRecord(record: userRecord)
            }
            result.append(PostWithAuthor(id: post.id, post: post, author: author!))
        }
        return result
    }
}
