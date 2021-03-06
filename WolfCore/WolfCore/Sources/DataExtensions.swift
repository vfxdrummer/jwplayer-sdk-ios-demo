//
//  DataExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

// Support the Serializable protocol used for caching

extension Data: Serializable {
    public typealias ValueType = Data

    public func serialize() -> Data {
        return self
    }

    public static func deserialize(from data: Data) throws -> Data {
        return data
    }

    public init(bytes: MutableRandomAccessSlice<Data>) {
        self.init(bytes: Array(bytes))
    }
}
