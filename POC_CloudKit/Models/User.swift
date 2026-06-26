//
//  User.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import Foundation
import CloudKit

struct User {
    var id        : UUID   = UUID()
    var name      : String = ""
    var imageData : Data   = Data()
    
    init(id: UUID, name: String, imageData: Data) {
        self.id        = id
        self.name      = name
        self.imageData = imageData
    }
    
    func toDictionary() -> [String : Any] {
        return ["id": id, "name" : name, "imageData" : imageData]
    }
    
    static func fromRecord(record: CKRecord) -> User? {
        guard let id = record.value(forKey: "id") as? UUID,
              let name = record.value(forKey: "name") as? String,
              let imageData = record.value(forKey: "imageData") as? Data
        else {
            print("Convertion Error")
            return nil
        }
        return User(id: id, name: name, imageData: imageData)
    }
}

struct PrivateUser {
    private(set) var id        : UUID = UUID()
    private(set) var privateID : CKRecord.ID = .init(recordName: "PrivateUser")
    
    var name      : String = ""
    var imageData : Data   = Data()
    
    init(privateID: CKRecord.ID, id: UUID = UUID(), name: String, imageData: Data) {
        self.id        = id
        self.privateID = privateID
        self.name      = name
        self.imageData = imageData
    }
    
    func toDictionary() -> [String : Any] {
        return ["name" : name, "imageData" : imageData]
    }
    
    static func fromRecord(record: CKRecord) -> PrivateUser? {
        guard let privateID = record.value(forKey: "privateID") as? CKRecord.ID,
              let id = record.value(forKey: "id") as? UUID,
              let name = record.value(forKey: "name") as? String,
              let imageData = record.value(forKey: "imageData") as? Data else {
            print("Convertion Error")
            return nil
        }
        return PrivateUser(privateID: privateID, id: id, name: name, imageData: imageData)
    }
}
