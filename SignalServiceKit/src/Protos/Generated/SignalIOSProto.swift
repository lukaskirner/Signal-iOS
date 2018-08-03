//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

import Foundation

// WARNING: This code is generated. Only edit within the markers.

public enum SignalIOSProtoError: Error {
    case invalidProtobuf(description: String)
}

// MARK: - SignalIOSProtoBackupSnapshotBackupEntity

@objc public class SignalIOSProtoBackupSnapshotBackupEntity: NSObject {

    // MARK: - SignalIOSProtoBackupSnapshotBackupEntityType

    @objc public enum SignalIOSProtoBackupSnapshotBackupEntityType: Int32 {
        case unknown = 0
        case migration = 1
        case thread = 2
        case interaction = 3
        case attachment = 4
    }

    private class func SignalIOSProtoBackupSnapshotBackupEntityTypeWrap(_ value: IOSProtos_BackupSnapshot.BackupEntity.TypeEnum) -> SignalIOSProtoBackupSnapshotBackupEntityType {
        switch value {
        case .unknown: return .unknown
        case .migration: return .migration
        case .thread: return .thread
        case .interaction: return .interaction
        case .attachment: return .attachment
        }
    }

    private class func SignalIOSProtoBackupSnapshotBackupEntityTypeUnwrap(_ value: SignalIOSProtoBackupSnapshotBackupEntityType) -> IOSProtos_BackupSnapshot.BackupEntity.TypeEnum {
        switch value {
        case .unknown: return .unknown
        case .migration: return .migration
        case .thread: return .thread
        case .interaction: return .interaction
        case .attachment: return .attachment
        }
    }

    // MARK: - SignalIOSProtoBackupSnapshotBackupEntityBuilder

    @objc public class SignalIOSProtoBackupSnapshotBackupEntityBuilder: NSObject {

        private var proto = IOSProtos_BackupSnapshot.BackupEntity()

        @objc public override init() {}

        @objc public func setType(_ valueParam: SignalIOSProtoBackupSnapshotBackupEntityType) {
            proto.type = SignalIOSProtoBackupSnapshotBackupEntityTypeUnwrap(valueParam)
        }

        @objc public func setEntityData(_ valueParam: Data) {
            proto.entityData = valueParam
        }

        @objc public func build() throws -> SignalIOSProtoBackupSnapshotBackupEntity {
            let wrapper = try SignalIOSProtoBackupSnapshotBackupEntity.parseProto(proto)
            return wrapper
        }
    }

    fileprivate let proto: IOSProtos_BackupSnapshot.BackupEntity

    @objc public let type: SignalIOSProtoBackupSnapshotBackupEntityType
    @objc public let entityData: Data

    private init(proto: IOSProtos_BackupSnapshot.BackupEntity,
                 type: SignalIOSProtoBackupSnapshotBackupEntityType,
                 entityData: Data) {
        self.proto = proto
        self.type = type
        self.entityData = entityData
    }

    @objc
    public func serializedData() throws -> Data {
        return try self.proto.serializedData()
    }

    @objc public class func parseData(_ serializedData: Data) throws -> SignalIOSProtoBackupSnapshotBackupEntity {
        let proto = try IOSProtos_BackupSnapshot.BackupEntity(serializedData: serializedData)
        return try parseProto(proto)
    }

    fileprivate class func parseProto(_ proto: IOSProtos_BackupSnapshot.BackupEntity) throws -> SignalIOSProtoBackupSnapshotBackupEntity {
        guard proto.hasType else {
            throw SignalIOSProtoError.invalidProtobuf(description: "\(logTag) missing required field: type")
        }
        let type = SignalIOSProtoBackupSnapshotBackupEntityTypeWrap(proto.type)

        guard proto.hasEntityData else {
            throw SignalIOSProtoError.invalidProtobuf(description: "\(logTag) missing required field: entityData")
        }
        let entityData = proto.entityData

        // MARK: - Begin Validation Logic for SignalIOSProtoBackupSnapshotBackupEntity -

        // MARK: - End Validation Logic for SignalIOSProtoBackupSnapshotBackupEntity -

        let result = SignalIOSProtoBackupSnapshotBackupEntity(proto: proto,
                                                              type: type,
                                                              entityData: entityData)
        return result
    }
}

// MARK: - SignalIOSProtoBackupSnapshot

@objc public class SignalIOSProtoBackupSnapshot: NSObject {

    // MARK: - SignalIOSProtoBackupSnapshotBuilder

    @objc public class SignalIOSProtoBackupSnapshotBuilder: NSObject {

        private var proto = IOSProtos_BackupSnapshot()

        @objc public override init() {}

        @objc public func addEntity(_ valueParam: SignalIOSProtoBackupSnapshotBackupEntity) {
            var items = proto.entity
            items.append(valueParam.proto)
            proto.entity = items
        }

        @objc public func build() throws -> SignalIOSProtoBackupSnapshot {
            let wrapper = try SignalIOSProtoBackupSnapshot.parseProto(proto)
            return wrapper
        }
    }

    fileprivate let proto: IOSProtos_BackupSnapshot

    @objc public let entity: [SignalIOSProtoBackupSnapshotBackupEntity]

    private init(proto: IOSProtos_BackupSnapshot,
                 entity: [SignalIOSProtoBackupSnapshotBackupEntity]) {
        self.proto = proto
        self.entity = entity
    }

    @objc
    public func serializedData() throws -> Data {
        return try self.proto.serializedData()
    }

    @objc public class func parseData(_ serializedData: Data) throws -> SignalIOSProtoBackupSnapshot {
        let proto = try IOSProtos_BackupSnapshot(serializedData: serializedData)
        return try parseProto(proto)
    }

    fileprivate class func parseProto(_ proto: IOSProtos_BackupSnapshot) throws -> SignalIOSProtoBackupSnapshot {
        var entity: [SignalIOSProtoBackupSnapshotBackupEntity] = []
        for item in proto.entity {
            let wrapped = try SignalIOSProtoBackupSnapshotBackupEntity.parseProto(item)
            entity.append(wrapped)
        }

        // MARK: - Begin Validation Logic for SignalIOSProtoBackupSnapshot -

        // MARK: - End Validation Logic for SignalIOSProtoBackupSnapshot -

        let result = SignalIOSProtoBackupSnapshot(proto: proto,
                                                  entity: entity)
        return result
    }
}
