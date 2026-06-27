//
//  ContentView.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @State var viewModel : ContentViewModel
    @State var posts     : [Post]
    
    init(container: CKContainer) {
        _viewModel = State(wrappedValue: ContentViewModel(container: container))
        self.posts = []
    }
    var body: some View {
        VStack {
            List {
                ForEach(posts) { post in
                    Text(post.text)
                }
            }
        }
        .padding()
        .onAppear{
            Task{
                posts = await viewModel.fetchAllPosts()
            }
        }
    }
}

#Preview {
    ContentView(container: CKContainer.default())
}
