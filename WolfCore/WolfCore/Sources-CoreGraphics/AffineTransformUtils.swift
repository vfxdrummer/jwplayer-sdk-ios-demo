//
//  AffineTransformUtils.swift
//  WolfCore
//
//  Created by Wolf McNally on 7/15/15.
//  Copyright © 2015 Arciem LLC. All rights reserved.
//

import CoreGraphics

extension CGAffineTransform {
    public init(scaling s: CGVector) {
        self.init(scaleX: s.dx, y: s.dy)
    }

    public init(translation t: CGVector) {
        self.init(translationX: t.dx, y: t.dy)
    }

    public func scaled(by v: CGVector) -> CGAffineTransform {
        return scaledBy(x: v.dx, y: v.dy)
    }

    public func translated(by v: CGVector) -> CGAffineTransform {
        return translatedBy(x: v.dx, y: v.dy)
    }
}
