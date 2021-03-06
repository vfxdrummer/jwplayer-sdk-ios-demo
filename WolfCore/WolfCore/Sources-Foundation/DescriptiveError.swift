//
//  DescriptiveError.swift
//  WolfCore
//
//  Created by Wolf McNally on 12/3/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

public protocol DescriptiveError: Error, CustomStringConvertible {
    /// A human-readable error message.
    var message: String { get }

    /// A numeric code for the error.
    var code: Int { get }

    /// A non-user-facing identifier used for automated UI testing
    var identifier: String { get }

    var isCancelled: Bool { get }
}
