//
//  ConcealerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/14/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class ConcealerView: GradientOverlayView {
    private let color: UIColor
    private let fadeDistance: CGFloat

    private var leadingConstraint: NSLayoutConstraint!

    public init(color: UIColor, fadeDistance: CGFloat) {
        self.color = color
        self.fadeDistance = fadeDistance
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()
        startPoint = CGPoint(x: 0, y: 0.5)
        colorFracs = [
            (Color(color.withAlphaComponent(0.0)), 0.0),
            (Color(color), 1.0)
        ]
    }

    public override func didMoveToSuperview() {
        guard let superview = superview else { return }

        leadingConstraint = leadingAnchor == superview.leadingAnchor - fadeDistance
        activateConstraints(
            topAnchor == superview.topAnchor,
            bottomAnchor == superview.bottomAnchor,
            widthAnchor == superview.widthAnchor + fadeDistance,
            leadingConstraint
        )
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        endPoint = CGPoint(x: fadeDistance / bounds.width, y: 0.5)
    }

    public func conceal(animated: Bool) {
        guard let superview = superview else { return }

        leadingConstraint.isActive = false
        leadingConstraint = activateConstraint(leadingAnchor == superview.leadingAnchor - fadeDistance)
        alpha = 0
        superview.layoutIfNeeded()
        dispatchAnimated(animated) {
            self.alpha = 1
        }
    }

    public func reveal(animated: Bool) {
        guard let superview = superview else { return }
        leadingConstraint.isActive = false
        leadingConstraint = activateConstraint(leadingAnchor == superview.trailingAnchor)
        dispatchAnimated(animated, duration: 1.0, options: [.curveLinear]) {
            superview.layoutIfNeeded()
        }
    }
}
