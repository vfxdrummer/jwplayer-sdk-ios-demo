//
//  HexTests.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import XCTest
@testable import WolfCore

class HexTests: XCTestCase {
    let knownData = Data(bytes: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
    let knownString = "0123456789abcdef"
    let knownByte: UInt8 = 0x8e
    let knownByteString = "8e"

    func testDataToHex() {
        let hex = knownData |> Hex.init
        XCTAssert(hex.data == knownData)
        XCTAssert(hex.string == knownString)
    }

    func testHexToData() {
        let data = try! knownString |> Hex.init |> Data.init
        XCTAssert(data == knownData)
    }

    func testHexToString() {
        let string = try! knownString |> Hex.init |> String.init
        XCTAssert(string == knownString)
    }

    func testByteToString() {
        let string = knownByte |> Hex.init |> String.init
        XCTAssert(string == knownByteString)
    }

    func testStringToByte() {
        let byte = try! knownByteString |> Hex.init |> UInt8.init
        XCTAssert(byte == knownByte)
    }
}
