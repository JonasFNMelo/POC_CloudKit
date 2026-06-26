//
//  Post.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import Foundation
import CloudKit

struct Post {
    var text       : String = ""
    var imagesData : [Data] = []
    var isPrivate  : Bool   = false
    
    init(text: String, imagesData: [Data], isPrivate: Bool) {
        self.text       = text
        self.imagesData = imagesData
        self.isPrivate  = isPrivate
    }
    
    func toDictionary() -> [String : Any] {
        return ["text" : text, "imagesData" : imagesData, "isPrivate" : isPrivate]
    }
    
    static func fromRecord(record: CKRecord) -> Post? {
        guard let text = record.value(forKey: "text") as? String,
              let imagesData = record.value(forKey: "imagesData") as? [Data],
              let isPrivate = record.value(forKey: "isPrivate") as? Bool
        else {
            print("Convertion Error")
            return nil
        }
        return Post(text: text, imagesData: imagesData, isPrivate: isPrivate)
    }
}
