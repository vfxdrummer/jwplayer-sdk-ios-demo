//
//  KeyChain.swift
//  WolfCore
//
//  Created by Wolf McNally on 6/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

private let defaultAccount = "default"

public struct KeyChain {
    public enum Error: Swift.Error {
        case couldNotAdd(Int)
        case couldNotDelete(Int)
        case couldNotUpdate(Int)
        case couldNotRead(Int)
        case wrongType
    }

    public static func add(data: Data, for key: String, in account: String = defaultAccount) throws {
        let query: [NSString : Any] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecAttrLabel : key,
            kSecAttrAccount : account,
            kSecValueData : data
        ]
        let result = SecItemAdd(query as NSDictionary, nil)
        guard result == errSecSuccess else {
            throw Error.couldNotAdd(Int(result))
        }
    }

    public static func add(string: String, for key: String, in account: String = defaultAccount) throws {
        try add(data: string |> UTF8.init |> Data.init, for: key, in: account)
    }

    public static func delete(key: String, account: String = defaultAccount) throws {
        let query: [NSString : Any] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecAttrAccount : account,
            kSecReturnAttributes : true,
            kSecReturnData : true
        ]

        let result = SecItemDelete(query as NSDictionary)
        guard result == errSecSuccess else {
            throw Error.couldNotDelete(Int(result))
        }
    }

    public static func update(data: Data, for key: String, in account: String = defaultAccount, addIfNotFound: Bool = true) throws {
        let query: [NSString : Any] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : account,
            kSecAttrService : key,
            ]

        let queryNew: [NSString : Any] = [
            kSecAttrAccount : account,
            kSecAttrService : key,
            kSecValueData : data
        ]

        let result = SecItemUpdate(query as NSDictionary, queryNew as NSDictionary)
        if result == errSecItemNotFound && addIfNotFound {
            try add(data: data, for: key, in: account)
            return
        }

        guard result == errSecSuccess else {
            throw Error.couldNotUpdate(Int(result))
        }
    }

    public static func update(string: String, for key: String, in account: String = defaultAccount, addIfNotFound: Bool = true) throws {
        try update(data: string |> UTF8.init |> Data.init, for: key, in: account, addIfNotFound: addIfNotFound)
    }

    public static func update(number: NSNumber, for key: String, in account: String = defaultAccount, addIfNotFound: Bool = true) throws {
        try update(data: NSKeyedArchiver.archivedData(withRootObject: number), for: key, in: account, addIfNotFound: addIfNotFound)
    }

    public static func update(bool: Bool, for key: String, in account: String = defaultAccount, addIfNotFound: Bool = true) throws {
        try update(number:(bool as NSNumber), for: key, in: account, addIfNotFound: addIfNotFound)
    }

    public static func update(json: JSON, for key: String, in account: String = defaultAccount, addIfNotFound: Bool = true) throws {
        try update(data: json.data, for: key, in: account, addIfNotFound: addIfNotFound)
    }

    public static func data(for key: String, in account: String = defaultAccount) throws -> Data? {
        let query: [NSString : Any] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecAttrAccount : account,
            kSecReturnAttributes : true,
            kSecReturnData : true
        ]

        var value: CFTypeRef?
        let result = SecItemCopyMatching(query as NSDictionary, &value)
        guard result != errSecItemNotFound else {
            return nil
        }
        guard result == errSecSuccess else {
            throw Error.couldNotRead(Int(result))
        }
        guard let dict = value as? [NSString: Any] else {
            throw Error.wrongType
        }
        guard let data = dict[kSecValueData] as? Data else {
            return nil
        }
        return data
    }

    public static func string(for key: String, in account: String = defaultAccount) throws -> String? {
        guard let data = try data(for: key, in: account) else {
            return nil
        }
        return try data |> UTF8.init |> String.init
    }

    public static func number(for key: String, in account: String = defaultAccount) throws -> NSNumber? {
        guard let data = try data(for: key, in: account) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSNumber
    }

    public static func bool(for key: String, in account: String = defaultAccount) throws -> Bool? {
        return try number(for: key, in: account) as? Bool
    }

    public static func json(for key: String, in account: String = defaultAccount) throws -> JSON? {
        guard let data = try data(for: key, in: account) else { return nil }
        return try data |> JSON.init
    }
}
