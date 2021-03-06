//
//  BundleExtensions.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import Foundation

/// WolfCore.BundleClass.self can be used as an argument to the Bundle.findBundle(forClass:) method to search within this framework bundle.
public class BundleClass { }

extension Bundle {
    /// Similar to Bundle.bundleForClass, except if aClass is nil (or omitted) the main bundle is returned
    public static func findBundle(forClass aClass: AnyClass? = nil) -> Bundle {
        let bundle: Bundle
        if let aClass = aClass {
            bundle = Bundle(for: aClass)
        } else {
            bundle = Bundle.main
        }
        return bundle
    }

    public static func urlForResource(_ name: String, withExtension anExtension: String? = nil, subdirectory subpath: String? = nil) -> (Bundle) throws -> URL {
        return { bundle in
            guard let url = bundle.url(forResource: name, withExtension: anExtension, subdirectory: subpath) else {
                throw GeneralError(message: "Resource not found.")
            }
            return url
        }
    }
}
