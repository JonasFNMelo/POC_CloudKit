//
//  ProfileViewModel.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 27/06/26.
//

import Foundation
import CloudKit

class ProfileViewModel {
    func fetchPostsFromUser(user: User) async -> [Post]{
        guard let userRecord = await CloudKitService.shared.fetchPublicUser(id: user.id),
              let postsRecord = await CloudKitService.shared.fetchAllPostsRecordsFromUserID(recordID: userRecord.recordID)
        else { return [] }
        
        return postsRecord.compactMap { Post.fromRecord(record: $0) }
    }
}
