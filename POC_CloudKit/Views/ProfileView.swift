//
//  ProfileView.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 27/06/26.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel : ProfileViewModel = ProfileViewModel()
    @State var posts     : [Post]           = []
    let user : User
    
    var body: some View {
        VStack{
            Text(user.name)
            List {
                ForEach(posts) { post in
                    Text(post.text)
                }
            }
            .onAppear {
                Task {
                    posts = await viewModel.fetchPostsFromUser(user: user)
                }
            }
        }
    }
}

#Preview {
    let user = User(id: UUID(),name: "Default",imageData: Data())
    ProfileView(user: user)
}
