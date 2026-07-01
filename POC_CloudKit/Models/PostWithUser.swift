//
//  PostWithAuthor.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 27/06/26.
//

import SwiftUI

struct PostWithUser: Identifiable {
    var id   : UUID?
    var post : Post
    var user : User
}
