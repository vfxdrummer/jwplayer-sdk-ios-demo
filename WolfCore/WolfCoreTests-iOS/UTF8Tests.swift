//
//  UTF8Tests.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/21/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import XCTest
@testable import WolfCore

class UTF8Tests: XCTestCase {
    let knownData = try! "f09f92aaf09f8fbdf09f90bae29da4efb88f" |> Hex.init |> Data.init
    let knownString = "💪🏽🐺❤️"

    func testDataToUTF8() {
        let utf8 = try! knownData |> UTF8.init
        XCTAssert(utf8.data == knownData)
        XCTAssert(utf8.string == knownString)
    }

    func testUTF8ToData() {
        let data = knownString |> UTF8.init |> Data.init
        XCTAssert(data == knownData)
    }
}
