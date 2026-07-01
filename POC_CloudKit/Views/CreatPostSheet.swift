//
//  CreatPostSheet.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 27/06/26.
//

import SwiftUI
import PhotosUI

struct CreatPostSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel       : CreatPostSheetViewModel = CreatPostSheetViewModel()
    @State var text            : String                  = ""
    @State var isPrivete       : Bool                    = false
    @State var photoPickerItem : PhotosPickerItem?
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                //PhotosPicker("Selecione sua Imagem", selection: $photoPickerItem)
                TextField("Digite o seu texto", text: $text)
                Toggle("Este é um post privado?", isOn: $isPrivete)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task{
                            let post = Post(text: text, imagesData: [], isPrivate: isPrivete)
                            await viewModel.savePost(post: post)
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    CreatPostSheet()
}
