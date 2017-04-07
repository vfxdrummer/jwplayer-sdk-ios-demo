//
//  RegularExpressionExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/5/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    #if os(Linux)
    public func firstMatch(inString string: String, options: NSMatchingOptions, range: Range<String.Index>? = nil) -> NSTextCheckingResult? {
        let range = range ?? string.range
        let nsRange = string.nsRange(from: range)!
        return firstMatch(in: string, options: options, range: nsRange)
    }

    public func matchedSubstrings(inString string: String, options: NSMatchingOptions = [], range: Range<String.Index>? = nil) -> [String]? {
        var result: [String]! = nil
        if let textCheckingResult = self.firstMatch(inString: string, options: options, range: range) {
            result = [String]()
            for range in textCheckingResult.captureRanges(inString: string) {
                let matchText = string.substring(with: range)
                result.append(matchText)
            }
        }
        return result
    }
    #else
    public func firstMatch(inString string: String, options: NSRegularExpression.MatchingOptions, range: Range<String.Index>? = nil) -> NSTextCheckingResult? {
        let range = range ?? string.stringRange
        let nsRange = string.nsRange(from: range)!
        return firstMatch(in: string, options: options, range: nsRange)
    }

    public func matchedSubstrings(inString string: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> [String]? {
        var result: [String]! = nil
        if let textCheckingResult = self.firstMatch(inString: string, options: options, range: range) {
            result = [String]()
            for range in textCheckingResult.captureRanges(inString: string) {
                let matchText = string.substring(with: range)
                result.append(matchText)
            }
        }
        return result
    }
    #endif
}
