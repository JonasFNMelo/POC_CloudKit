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
    
    func saveUser(pUser: PrivateUser) async {
        let privateUserRecord = CKRecord(recordType: RecordType.privateUser.rawValue)
        privateUserRecord.setValuesForKeys(pUser.toDictionary())
        
        let publicUser = User(id: pUser.id, name: pUser.name, imageData: pUser.imageData)
        let publicUserRecord = CKRecord(recordType: RecordType.user.rawValue)
        publicUserRecord.setValuesForKeys(publicUser.toDictionary())
        
        await ckService.savePrivateRecord(record: privateUserRecord)
        await ckService.savePublicRecord(record: publicUserRecord)
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
            await ckService.savePrivateRecord(record: postRecord)
        case false:
            await ckService.savePublicRecord(record: postRecord)
        }
        
        var currentPostRefs = userRecord.value(forKey: "postRefs") as? [CKRecord.Reference] ?? []
        currentPostRefs.append(CKRecord.Reference(recordID: postRecord.recordID, action: .none))
        userRecord["postRefs"] = currentPostRefs
        await ckService.savePublicRecord(record: userRecord)
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
    
    func getPublicUser() async -> CKRecord? {
        guard let privateRecord = await ckService.fetchPrivateUser(),
              let privateUser = PrivateUser.fromRecord(record: privateRecord)
        else {
            return nil
        }
        return await ckService.fetchPublicUser(id: privateUser.id)
    }
    
    func getAllPostsWithAuthor() async -> [PostWithAuthor] {
        guard let postRecords = await ckService.fetchAllPublicRecords(recordType: .post) else { return [] }
        
        var result: [PostWithAuthor] = []
        
        for postRecord in postRecords {
            guard let post = Post.fromRecord(record: postRecord) else { continue }
            
            var author: User? = nil
            if let authorRef = post.authorRef,
               let userRecord = await ckService.fetchPublicUser(id: authorRef.recordID) {
                author = User.fromRecord(record: userRecord)
            }
            
            result.append(PostWithAuthor(id: post.id, post: post, author: author))
        }
        return result
    }
}
