//
//  EditableContainerView.swift
//  WolfCore
//
//  Created by Wolf McNally on 3/13/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

public class EditableContainerView: View, Editable {
    public var isEditing = false
    public unowned let normalView: UIView
    public unowned let editingView: UIView

    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!

    public init(normalView: UIView, editingView: UIView) {
        self.normalView = normalView
        self.editingView = editingView
        super.init(frame: .zero)

        //isTransparentToTouches = true

        widthConstraint = activateConstraint(widthAnchor == 20 =&= UILayoutPriorityDefaultHigh)
        heightConstraint = activateConstraint(heightAnchor == 20 =&= UILayoutPriorityDefaultHigh)

        addContentView(normalView)
        addContentView(editingView)

        syncToEditing(animated: false)
    }

    private func addContentView(_ view: UIView) {
        self => [
            view
        ]
        view.constrainCenterToCenter()
        view.constrainMaxWidthToWidth()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    private weak var currentContentView: UIView!

    private func setContentView(_ view: UIView) {
        currentContentView = view
        view.alpha = 0
        bringSubview(toFront: view)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        setNeedsUpdateConstraints()
    }

    public override func updateConstraints() {
        super.updateConstraints()
        guard let currentContentView = currentContentView else { return }
        widthConstraint.constant = currentContentView.frame.width
        heightConstraint.constant = currentContentView.frame.height
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setup() {
        super.setup()
        clipsToBounds = true
    }

    public func syncToEditing(animated: Bool) {
        switch isEditing {
        case false:
            setContentView(normalView)
        case true:
            setContentView(editingView)
        }
        propagateSkin(why: "addedView")
        setNeedsLayout()
        dispatchAnimated(animated) {
            switch self.isEditing {
            case false:
                self.normalView.alpha = 1
                self.editingView.alpha = 0
            case true:
                self.editingView.alpha = 1
                self.normalView.alpha = 0
            }
            self.layoutIfNeeded()
        }
    }
}
