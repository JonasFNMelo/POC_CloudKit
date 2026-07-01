//
//  ContentView.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    @AppStorage("firstTime") var firstTime: Bool  = false
    @State var viewModel       : ContentViewModel = ContentViewModel()
    @State var postsWithAuthor : [PostWithUser]   = []
    @State var isSheetShowing  : Bool             = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(postsWithAuthor) { pwu in
                        NavigationLink(destination: ProfileView(user: pwu.user)) {
                            Text(pwu.user.name)
                        }
                        Text(pwu.post.text)
                    }
                }
            }
            .refreshable {
                Task {
                    postsWithAuthor = await viewModel.fetchAllPostsWithAuthor()
                }
            }
            .padding()
            .onAppear{
                Task {
                    postsWithAuthor = await viewModel.fetchAllPostsWithAuthor()
                    if !firstTime {

                            guard let cloudKitID = try? await CKContainer.default().userRecordID() else {return}
                            let pUser = PrivateUser(privateID: cloudKitID.recordName, name: "Jones", imageData: Data())
                            await viewModel.saveUser(pUser: pUser)
                        
                    }
                }
            }
            .sheet(isPresented: $isSheetShowing){
                CreatPostSheet()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        isSheetShowing = true
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
        }
    }
}

#Preview {
    ContentView()
}
