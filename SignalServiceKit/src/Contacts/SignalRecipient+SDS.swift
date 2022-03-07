//
//  Copyright (c) 2022 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDB
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct SignalRecipientRecord: SDSRecord {
    public weak var delegate: SDSRecordDelegate?

    public var tableMetadata: SDSTableMetadata {
        SignalRecipientSerializer.table
    }

    public static var databaseTableName: String {
        SignalRecipientSerializer.table.tableName
    }

    public var id: Int64?

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    // Properties
    public let devices: Data
    public let recipientPhoneNumber: String?
    public let recipientUUID: String?

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
        case devices
        case recipientPhoneNumber
        case recipientUUID
    }

    public static func columnName(_ column: SignalRecipientRecord.CodingKeys, fullyQualified: Bool = false) -> String {
        fullyQualified ? "\(databaseTableName).\(column.rawValue)" : column.rawValue
    }

    public func didInsert(with rowID: Int64, for column: String?) {
        guard let delegate = delegate else {
            owsFailDebug("Missing delegate.")
            return
        }
        delegate.updateRowId(rowID)
    }
}

// MARK: - Row Initializer

public extension SignalRecipientRecord {
    static var databaseSelection: [SQLSelectable] {
        CodingKeys.allCases
    }

    init(row: Row) {
        id = row[0]
        recordType = row[1]
        uniqueId = row[2]
        devices = row[3]
        recipientPhoneNumber = row[4]
        recipientUUID = row[5]
    }
}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(signalRecipientColumn column: SignalRecipientRecord.CodingKeys) {
        appendLiteral(SignalRecipientRecord.columnName(column))
    }
    mutating func appendInterpolation(signalRecipientColumnFullyQualified column: SignalRecipientRecord.CodingKeys) {
        appendLiteral(SignalRecipientRecord.columnName(column, fullyQualified: true))
    }
}

// MARK: - Deserialization

// TODO: Rework metadata to not include, for example, columns, column indices.
extension SignalRecipient {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: SignalRecipientRecord) throws -> SignalRecipient {

        guard let recordId = record.id else {
            throw SDSError.invalidValue
        }

        switch record.recordType {
        case .signalRecipient:

            let uniqueId: String = record.uniqueId
            let devicesSerialized: Data = record.devices
            let devices: NSOrderedSet = try SDSDeserialization.unarchive(devicesSerialized, name: "devices")
            let recipientPhoneNumber: String? = record.recipientPhoneNumber
            let recipientUUID: String? = record.recipientUUID

            return SignalRecipient(grdbId: recordId,
                                   uniqueId: uniqueId,
                                   devices: devices,
                                   recipientPhoneNumber: recipientPhoneNumber,
                                   recipientUUID: recipientUUID)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue
        }
    }
}

// MARK: - SDSModel

extension SignalRecipient: SDSModel {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return SignalRecipientSerializer(model: self)
        }
    }

    public func asRecord() throws -> SDSRecord {
        try serializer.asRecord()
    }

    public var sdsTableName: String {
        SignalRecipientRecord.databaseTableName
    }

    public static var table: SDSTableMetadata {
        SignalRecipientSerializer.table
    }
}

// MARK: - DeepCopyable

extension SignalRecipient: DeepCopyable {

    public func deepCopy() throws -> AnyObject {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        guard let id = self.grdbId?.int64Value else {
            throw OWSAssertionError("Model missing grdbId.")
        }

        do {
            let modelToCopy = self
            assert(type(of: modelToCopy) == SignalRecipient.self)
            let uniqueId: String = modelToCopy.uniqueId
            // NOTE: If this generates build errors, you made need to
            // implement DeepCopyable for this type in DeepCopy.swift.
            let devices: NSOrderedSet = try DeepCopies.deepCopy(modelToCopy.devices)
            let recipientPhoneNumber: String? = modelToCopy.recipientPhoneNumber
            let recipientUUID: String? = modelToCopy.recipientUUID

            return SignalRecipient(grdbId: id,
                                   uniqueId: uniqueId,
                                   devices: devices,
                                   recipientPhoneNumber: recipientPhoneNumber,
                                   recipientUUID: recipientUUID)
        }

    }
}

// MARK: - Table Metadata

extension SignalRecipientSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static var idColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "id", columnType: .primaryKey) }
    static var recordTypeColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "recordType", columnType: .int64) }
    static var uniqueIdColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, isUnique: true) }
    // Properties
    static var devicesColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "devices", columnType: .blob) }
    static var recipientPhoneNumberColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "recipientPhoneNumber", columnType: .unicodeString, isOptional: true) }
    static var recipientUUIDColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "recipientUUID", columnType: .unicodeString, isOptional: true) }

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static var table: SDSTableMetadata {
        SDSTableMetadata(collection: SignalRecipient.collection(),
                         tableName: "model_SignalRecipient",
                         columns: [
        idColumn,
        recordTypeColumn,
        uniqueIdColumn,
        devicesColumn,
        recipientPhoneNumberColumn,
        recipientUUIDColumn
        ])
    }
}

// MARK: - Save/Remove/Update

@objc
public extension SignalRecipient {
    func anyInsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .insert, transaction: transaction)
    }

    // Avoid this method whenever feasible.
    //
    // If the record has previously been saved, this method does an overwriting
    // update of the corresponding row, otherwise if it's a new record, this
    // method inserts a new row.
    //
    // For performance, when possible, you should explicitly specify whether
    // you are inserting or updating rather than calling this method.
    func anyUpsert(transaction: SDSAnyWriteTransaction) {
        let isInserting: Bool
        if SignalRecipient.anyFetch(uniqueId: uniqueId, transaction: transaction) != nil {
            isInserting = false
        } else {
            isInserting = true
        }
        sdsSave(saveMode: isInserting ? .insert : .update, transaction: transaction)
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    func anyUpdate(transaction: SDSAnyWriteTransaction, block: (SignalRecipient) -> Void) {

        block(self)

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        // Don't apply the block twice to the same instance.
        // It's at least unnecessary and actually wrong for some blocks.
        // e.g. `block: { $0 in $0.someField++ }`
        if dbCopy !== self {
            block(dbCopy)
        }

        dbCopy.sdsSave(saveMode: .update, transaction: transaction)
    }

    // This method is an alternative to `anyUpdate(transaction:block:)` methods.
    //
    // We should generally use `anyUpdate` to ensure we're not unintentionally
    // clobbering other columns in the database when another concurrent update
    // has occured.
    //
    // There are cases when this doesn't make sense, e.g. when  we know we've
    // just loaded the model in the same transaction. In those cases it is
    // safe and faster to do a "overwriting" update
    func anyOverwritingUpdate(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .update, transaction: transaction)
    }

    func anyRemove(transaction: SDSAnyWriteTransaction) {
        sdsRemove(transaction: transaction)
    }

    func anyReload(transaction: SDSAnyReadTransaction) {
        anyReload(transaction: transaction, ignoreMissing: false)
    }

    func anyReload(transaction: SDSAnyReadTransaction, ignoreMissing: Bool) {
        guard let latestVersion = type(of: self).anyFetch(uniqueId: uniqueId, transaction: transaction) else {
            if !ignoreMissing {
                owsFailDebug("`latest` was unexpectedly nil")
            }
            return
        }

        setValuesForKeys(latestVersion.dictionaryValue)
    }
}

// MARK: - SignalRecipientCursor

@objc
public class SignalRecipientCursor: NSObject, SDSCursor {
    private let transaction: GRDBReadTransaction
    private let cursor: RecordCursor<SignalRecipientRecord>?

    init(transaction: GRDBReadTransaction, cursor: RecordCursor<SignalRecipientRecord>?) {
        self.transaction = transaction
        self.cursor = cursor
    }

    public func next() throws -> SignalRecipient? {
        guard let cursor = cursor else {
            return nil
        }
        guard let record = try cursor.next() else {
            return nil
        }
        let value = try SignalRecipient.fromRecord(record)
        Self.modelReadCaches.signalRecipientReadCache.didReadSignalRecipient(value, transaction: transaction.asAnyRead)
        return value
    }

    public func all() throws -> [SignalRecipient] {
        var result = [SignalRecipient]()
        while true {
            guard let model = try next() else {
                break
            }
            result.append(model)
        }
        return result
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
public extension SignalRecipient {
    class func grdbFetchCursor(transaction: GRDBReadTransaction) -> SignalRecipientCursor {
        let database = transaction.database
        do {
            let cursor = try SignalRecipientRecord.fetchCursor(database)
            return SignalRecipientCursor(transaction: transaction, cursor: cursor)
        } catch {
            owsFailDebug("Read failed: \(error)")
            return SignalRecipientCursor(transaction: transaction, cursor: nil)
        }
    }

    // Fetches a single model by "unique id".
    class func anyFetch(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> SignalRecipient? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(SignalRecipientRecord.databaseTableName) WHERE \(signalRecipientColumn: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            block: @escaping (SignalRecipient, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerate(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batched: Bool = false,
                            block: @escaping (SignalRecipient, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerate(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batchSize: UInt,
                            block: @escaping (SignalRecipient, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let cursor = SignalRecipient.grdbFetchCursor(transaction: grdbTransaction)
            Batching.loop(batchSize: batchSize,
                          loopBlock: { stop in
                                do {
                                    guard let value = try cursor.next() else {
                                        stop.pointee = true
                                        return
                                    }
                                    block(value, stop)
                                } catch let error {
                                    owsFailDebug("Couldn't fetch model: \(error)")
                                }
                              })
        }
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerateUniqueIds(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batched: Bool = false,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerateUniqueIds(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batchSize: UInt,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            grdbEnumerateUniqueIds(transaction: grdbTransaction,
                                   sql: """
                    SELECT \(signalRecipientColumn: .uniqueId)
                    FROM \(SignalRecipientRecord.databaseTableName)
                """,
                batchSize: batchSize,
                block: block)
        }
    }

    // Does not order the results.
    class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [SignalRecipient] {
        var result = [SignalRecipient]()
        anyEnumerate(transaction: transaction) { (model, _) in
            result.append(model)
        }
        return result
    }

    // Does not order the results.
    class func anyAllUniqueIds(transaction: SDSAnyReadTransaction) -> [String] {
        var result = [String]()
        anyEnumerateUniqueIds(transaction: transaction) { (uniqueId, _) in
            result.append(uniqueId)
        }
        return result
    }

    class func anyCount(transaction: SDSAnyReadTransaction) -> UInt {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            return SignalRecipientRecord.ows_fetchCount(grdbTransaction.database)
        }
    }

    // WARNING: Do not use this method for any models which do cleanup
    //          in their anyWillRemove(), anyDidRemove() methods.
    class func anyRemoveAllWithoutInstantation(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .grdbWrite(let grdbTransaction):
            do {
                try SignalRecipientRecord.deleteAll(grdbTransaction.database)
            } catch {
                owsFailDebug("deleteAll() failed: \(error)")
            }
        }

        if ftsIndexMode != .never {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyRemoveAllWithInstantation(transaction: SDSAnyWriteTransaction) {
        // To avoid mutationDuringEnumerationException, we need
        // to remove the instances outside the enumeration.
        let uniqueIds = anyAllUniqueIds(transaction: transaction)

        var index: Int = 0
        Batching.loop(batchSize: Batching.kDefaultBatchSize,
                      loopBlock: { stop in
            guard index < uniqueIds.count else {
                stop.pointee = true
                return
            }
            let uniqueId = uniqueIds[index]
            index = index + 1
            guard let instance = anyFetch(uniqueId: uniqueId, transaction: transaction) else {
                owsFailDebug("Missing instance.")
                return
            }
            instance.anyRemove(transaction: transaction)
        })

        if ftsIndexMode != .never {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyExists(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> Bool {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT EXISTS ( SELECT 1 FROM \(SignalRecipientRecord.databaseTableName) WHERE \(signalRecipientColumn: .uniqueId) = ? )"
            let arguments: StatementArguments = [uniqueId]
            return try! Bool.fetchOne(grdbTransaction.database, sql: sql, arguments: arguments) ?? false
        }
    }
}

// MARK: - Swift Fetch

public extension SignalRecipient {
    class func grdbFetchCursor(sql: String,
                               arguments: StatementArguments = StatementArguments(),
                               transaction: GRDBReadTransaction) -> SignalRecipientCursor {
        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            let cursor = try SignalRecipientRecord.fetchCursor(transaction.database, sqlRequest)
            return SignalRecipientCursor(transaction: transaction, cursor: cursor)
        } catch {
            Logger.verbose("sql: \(sql)")
            owsFailDebug("Read failed: \(error)")
            return SignalRecipientCursor(transaction: transaction, cursor: nil)
        }
    }

    class func grdbFetchOne(sql: String,
                            arguments: StatementArguments = StatementArguments(),
                            transaction: GRDBReadTransaction) -> SignalRecipient? {
        assert(sql.count > 0)

        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            guard let record = try SignalRecipientRecord.fetchOne(transaction.database, sqlRequest) else {
                return nil
            }

            let value = try SignalRecipient.fromRecord(record)
            Self.modelReadCaches.signalRecipientReadCache.didReadSignalRecipient(value, transaction: transaction.asAnyRead)
            return value
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class SignalRecipientSerializer: SDSSerializer {

    private let model: SignalRecipient
    public required init(model: SignalRecipient) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = model.grdbId?.int64Value

        let recordType: SDSRecordType = .signalRecipient
        let uniqueId: String = model.uniqueId

        // Properties
        let devices: Data = requiredArchive(model.devices)
        let recipientPhoneNumber: String? = model.recipientPhoneNumber
        let recipientUUID: String? = model.recipientUUID

        return SignalRecipientRecord(delegate: model, id: id, recordType: recordType, uniqueId: uniqueId, devices: devices, recipientPhoneNumber: recipientPhoneNumber, recipientUUID: recipientUUID)
    }
}

// MARK: - Deep Copy

#if TESTABLE_BUILD
@objc
public extension SignalRecipient {
    // We're not using this method at the moment,
    // but we might use it for validation of
    // other deep copy methods.
    func deepCopyUsingRecord() throws -> SignalRecipient {
        guard let record = try asRecord() as? SignalRecipientRecord else {
            throw OWSAssertionError("Could not convert to record.")
        }
        return try SignalRecipient.fromRecord(record)
    }
}
#endif
