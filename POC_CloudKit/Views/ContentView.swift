//
//  ContentView.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @State var viewModel       : ContentViewModel
    @State var postsWithAuthor : [PostWithAuthor]
    @State var isSheetShowing  : Bool
    
    init(container: CKContainer) {
        _viewModel       = State(wrappedValue: ContentViewModel(container: container))
        _postsWithAuthor = State(initialValue: [])
        _isSheetShowing  = State(initialValue: true)
    }
    var body: some View {
        VStack {
            List {
                ForEach(postsWithAuthor) { pwa in
                    Text(pwa.author.name)
                    Text(pwa.post.text)
                }
            }
        }
        .padding()
        .onAppear{
            Task{
                postsWithAuthor = await viewModel.fetchAllPostsWithAuthor()
            }
        }
        .sheet(isPresented: $isSheetShowing){
            CreatPostSheet()
        }
    }
}

#Preview {
    ContentView(container: CKContainer.default())
}
