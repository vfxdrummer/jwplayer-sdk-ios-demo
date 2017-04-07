//
//  Serializable.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public protocol Serializable {
    associatedtype ValueType

    func serialize() -> Data
    static func deserialize(from data: Data) throws -> ValueType
}
