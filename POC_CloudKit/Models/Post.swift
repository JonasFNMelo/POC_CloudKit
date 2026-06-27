//
//  Post.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import Foundation
import CloudKit

struct Post: Identifiable {
    var id         : UUID?                   = nil
    var text       : String                  = ""
    var imagesData : [Data]                  = []
    var isPrivate  : Bool                    = false
    var authorRef  : CKRecord.Reference?     = nil

    init(id: UUID? = nil, text: String, imagesData: [Data], isPrivate: Bool, authorRef: CKRecord.Reference? = nil) {
        self.id         = id
        self.text       = text
        self.imagesData = imagesData
        self.isPrivate  = isPrivate
        self.authorRef  = authorRef
    }

    func toDictionary() -> [String : Any] {
        var dict: [String : Any] = ["text": text, "imagesData": imagesData, "isPrivate": isPrivate]
        if let authorRef { dict["author"] = authorRef }
        if let id        { dict["id"] = id.uuidString }
        return dict
    }

    static func fromRecord(record: CKRecord) -> Post? {
        guard let text       = record.value(forKey: "text")       as? String,
              let imagesData = record.value(forKey: "imagesData") as? [Data],
              let isPrivate  = record.value(forKey: "isPrivate")  as? Bool
        else {
            print("Convertion Error")
            return nil
        }
        let authorRef = record.value(forKey: "author") as? CKRecord.Reference
        let id        = (record.value(forKey: "id") as? String).flatMap { UUID(uuidString: $0) }
        return Post(id: id, text: text, imagesData: imagesData, isPrivate: isPrivate, authorRef: authorRef)
    }
}
