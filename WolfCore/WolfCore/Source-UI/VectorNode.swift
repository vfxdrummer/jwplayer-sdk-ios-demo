//
//  VectorNode.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/19/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import Foundation
import SpriteKit

public class VectorNode: SKShapeNode {
    public var vector: CGVector? {
        didSet {
            sync()
        }
    }

    public var color: UIColor {
        didSet {
            sync()
        }
    }

    public init(vector: CGVector? = nil, color: UIColor = .red) {
        self.vector = vector
        self.color = color
        super.init()
        lineWidth = 2.0
    }

    public override func move(toParent parent: SKNode) {
        super.move(toParent: parent)
        sync()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func sync() {
        if let vector = vector {
            let path = CGMutablePath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(vector: vector))
            strokeColor = color
            self.path = path
            show()
        } else {
            hide()
        }
    }
}
