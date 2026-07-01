//
//  Post.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import Foundation
import CloudKit

struct Post: Identifiable {
    var id         : UUID                    = UUID()
    var text       : String                  = ""
    var imagesData : [Data]?                 = []
    var isPrivate  : Bool                    = false
    var userID     : CKRecord.Reference?     = nil

    init(id: UUID = UUID(), text: String, imagesData: [Data]?, isPrivate: Bool, userID: CKRecord.Reference? = nil) {
        self.id         = id
        self.text       = text
        self.imagesData = imagesData
        self.isPrivate  = isPrivate
        self.userID     = userID
    }

    func toDictionary() -> [String : Any] {
        var dict: [String : Any] = ["text": text, "isPrivate": isPrivate, "id": id.uuidString]
        if !imagesData!.isEmpty {
            dict["imagesData"] = imagesData
        }
        if let userID { dict["userID"] = userID }
        return dict
    }

    static func fromRecord(record: CKRecord) -> Post? {
        guard let text       = record.value(forKey: "text")       as? String,
              let imagesData = record.value(forKey: "imagesData") as? [Data]?,
              let isPrivate  = record.value(forKey: "isPrivate")  as? Bool,
              let userID     = record.value(forKey: "userID")     as? CKRecord.Reference,
              let idString   = record.value(forKey: "id")         as? String,
              let id         = UUID(uuidString: idString)
        else {
            print("Convertion Error")
            return nil
        }
        return Post(id: id, text: text, imagesData: imagesData, isPrivate: isPrivate, userID: userID)
    }
}
