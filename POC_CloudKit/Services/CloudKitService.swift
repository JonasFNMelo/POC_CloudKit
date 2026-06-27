//
//  CoreDataService.swift
//  POC_CloudKit
//
//  Created by Jonas Fernando Nascimento Melo on 26/06/26.
//

import Foundation
import CloudKit

@Observable
class CloudKitService {
    private var container        : CKContainer
    private var publicDatabase   : CKDatabase
    private var privateDatabase  : CKDatabase
    
    init(container: CKContainer) {
        self.container        = container
        self.publicDatabase   = container.publicCloudDatabase
        self.privateDatabase  = container.privateCloudDatabase
    }
    
    func savePublicRecord(record: CKRecord) async {
        do {
            try await self.publicDatabase.save(record)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func savePrivateRecord(record: CKRecord) async {
        do {
            try await self.privateDatabase.save(record)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllPublicRecords(recordType: RecordType) async -> [CKRecord]? {
        do {
            let query = CKQuery(recordType: recordType.rawValue, predicate: NSPredicate(value: true))
            let result = try await publicDatabase.records(matching: query)
            let records = result.matchResults.compactMap { try? $1.get() }
            
            return records
        }
        catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
    func isUserSaved() async -> Bool {
        do {
            let cloudKitID = try await container.userRecordID()
            let record = try await privateDatabase.record(for: cloudKitID)
            return true
        } catch {
            return false
        }
    }
    
    func fetchPrivateUser() async -> CKRecord? {
        do {
            let cloudKitID = try await container.userRecordID()
            let record = try await privateDatabase.record(for: cloudKitID)
            return record
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchPublicUser(id: UUID) async -> CKRecord? {
        do {
            let predicate = NSPredicate(format: "id == %@", id.uuidString)
            let query = CKQuery(recordType: RecordType.user.rawValue, predicate: predicate)
            let result = try await publicDatabase.records(matching: query)
            return result.matchResults.compactMap { try? $1.get() }.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchPublicUser(recordID: CKRecord.ID) async -> CKRecord? {
        do {
            return try await publicDatabase.record(for: recordID)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deletePublicRecord(record: CKRecord) async {
        do {
            try await publicDatabase.deleteRecord(withID: record.recordID)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func deletePrivateRecord(record: CKRecord) async {
        do {
            try await privateDatabase.deleteRecord(withID: record.recordID)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

//try await CKContainer.default().userRecordID()
