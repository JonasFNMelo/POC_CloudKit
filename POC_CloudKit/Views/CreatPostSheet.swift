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
    @State var text            : String = ""
    @State var photoPickerItem : PhotosPickerItem?
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                TextField("Digite o seu texto", text: $text)
                PhotosPicker("Selecione sua Imagem", selection: $photoPickerItem)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    dismiss
                } label: {
                    Image(systemName: "xmark")
                }
                
            }
            ToolbarItem {
                Button {
                    
                    dismiss
                } label: {
                    Image(systemName: "checkmark")
                }
                
            }
        }
    }
}

#Preview {
    CreatPostSheet()
}
