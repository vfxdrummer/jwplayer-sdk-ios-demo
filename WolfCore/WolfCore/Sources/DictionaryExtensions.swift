//
//  DictionaryExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 1/8/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

extension Dictionary {
    mutating func update(from dict: Dictionary) {
        for (key, value) in dict {
            self.updateValue(value, forKey: key)
        }
    }
}
