//
//  InFlightView.swift
//  WolfCore
//
//  Created by Wolf McNally on 5/26/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

private let animationDuration: TimeInterval = 0.3

public class InFlightView: View {
    private var columnsStackView: StackView!
    private var leftColumnView: View!
    private var rightColumnView: View!
    private var leftTokenViews = [InFlightTokenView]()
    private var rightTokenViews = [InFlightTokenView]()
    private var tokenViewsByID = [Int : InFlightTokenView]()
    private var tokenViewConstraintsByID = [Int: LayoutConstraintsGroup]()
    private var enteringTokenViews = [InFlightTokenView]()
    private var leavingTokenViews = [InFlightTokenView]()
    private var layoutCanceler: Cancelable?
    private let serializer = Serializer(label: "\(self)")
    private let spacing: CGFloat = 2

    public override var isHidden: Bool {
        didSet {
            if !isHidden {
                layoutTokenViews(animated: false)
            }
        }
    }

    private var needsTokenViewLayout = false {
        didSet {
            guard !isHidden else { return }

            if needsTokenViewLayout {
                if layoutCanceler == nil {
                    layoutCanceler = dispatchOnMain(afterDelay: 0.1) {
                        self.layoutCanceler = nil
                        self.layoutTokenViews(animated: true)
                    }
                }
            } else {
                layoutCanceler?.cancel()
                layoutCanceler = nil
            }
        }
    }

    public override func setup() {
        super.setup()
        #if !os(macOS)
        isTransparentToTouches = true
        #endif
        inFlightTracker.didStart = didStart
        inFlightTracker.didEnd = didEnd

        setupColumnViews()
    }

    private func addView(forToken token: InFlightToken) {
        let tokenView = InFlightTokenView()

        serializer.dispatch {
            self.leftTokenViews.insert(tokenView, at: 0)
            self.tokenViewsByID[token.id] = tokenView
            self.enteringTokenViews.append(tokenView)
        }

        self => [
            tokenView
        ]
        tokenView.token = token
        self.layout(tokenView: tokenView, index: 0, referenceView: self.leftColumnView)
        tokenView.alpha = 0.0
        tokenView.setNeedsLayout()
        tokenView.layoutIfNeeded()
        self.needsTokenViewLayout = true
    }

    private func moveViewToRight(forToken token: InFlightToken) {
        guard let tokenView = self.tokenViewsByID[token.id] else { return }
        if let index = self.leftTokenViews.index(of: tokenView) {
            serializer.dispatch {
                self.leftTokenViews.remove(at: index)
                self.rightTokenViews.insert(tokenView, at: 0)
            }
            self.needsTokenViewLayout = true
        }
        dispatchOnMain(afterDelay: 10.0) {
            self.removeView(forToken: token)
        }
    }

    private func updateView(forToken token: InFlightToken) {
        guard let tokenView = self.tokenViewsByID[token.id] else { return }
        tokenView.tokenChanged()
    }

    private func removeView(forToken token: InFlightToken) {
        guard let tokenView = self.tokenViewsByID[token.id] else { return }
        serializer.dispatch {
            self.leavingTokenViews.append(tokenView)
        }
        self.needsTokenViewLayout = true
    }

    private func layoutTokenViews(animated: Bool) {
        for tokenView in leavingTokenViews {
            dispatchAnimated(animated,
                duration: animationDuration,
                options: [.beginFromCurrentState, .curveEaseOut],
                animations: {
                    tokenView.alpha = 0.0
                },
                completion: { finished in
                    tokenView.removeFromSuperview()
                    self.tokenViewsByID.removeValue(forKey: tokenView.token.id)
                    if let index = self.leftTokenViews.index(of: tokenView) {
                        self.leftTokenViews.remove(at: index)
                    }
                    if let index = self.rightTokenViews.index(of: tokenView) {
                        self.rightTokenViews.remove(at: index)
                    }
                    self.needsTokenViewLayout = true
                }
            )
        }

        for (index, tokenView) in leftTokenViews.enumerated() {
            layout(tokenView: tokenView, index: index, referenceView: leftColumnView)
        }

        for (index, tokenView) in rightTokenViews.enumerated() {
            layout(tokenView: tokenView, index: index, referenceView: rightColumnView)
        }

        for tokenView in enteringTokenViews {
            dispatchAnimated(animated,
                duration: animationDuration,
                delay: 0.0,
                options: [.beginFromCurrentState, .curveEaseOut],
                animations: {
                    tokenView.alpha = 1.0
                }
            )
        }
        enteringTokenViews.removeAll()

        setNeedsLayout()

        dispatchAnimated(animated,
            duration: animationDuration,
            delay: 0.0,
            options: [.beginFromCurrentState, .curveEaseOut],
            animations: {
                self.layoutIfNeeded()
            }
        )
    }

    private func layout(tokenView: InFlightTokenView, index: Int, referenceView: OSView) {
        let token: InFlightToken = tokenView.token
        tokenViewConstraintsByID[token.id]?.isActive = false
        let viewY = CGFloat(index) * (InFlightTokenView.viewHeight + spacing)
        let constraints = [
            tokenView.leadingAnchor == referenceView.leadingAnchor,
            tokenView.trailingAnchor == referenceView.trailingAnchor,
            tokenView.topAnchor == referenceView.topAnchor + viewY,
            ]
        tokenViewConstraintsByID[token.id] = LayoutConstraintsGroup(constraints: constraints, active: true)
    }

    private func didStart(withToken token: InFlightToken) {
        dispatchOnMain {
            self.addView(forToken: token)
        }
    }

    private func didEnd(withToken token: InFlightToken) {
        dispatchOnMain {
            self.updateView(forToken: token)
            self.moveViewToRight(forToken: token)
        }
    }

    private func setupColumnViews() {
        leftColumnView = View()
        leftColumnView.isTransparentToTouches = true

        rightColumnView = View()
        rightColumnView.debugBackgroundColor = .blue
        rightColumnView.isTransparentToTouches = true

        columnsStackView = StackView(arrangedSubviews: [leftColumnView, rightColumnView])
        columnsStackView.isTransparentToTouches = true
        columnsStackView.axis = .horizontal
        columnsStackView.distribution = .fillEqually
        columnsStackView.alignment = .fill
        columnsStackView.spacing = 20.0

        self => [
            columnsStackView
        ]
        columnsStackView.constrainFrame(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), identifier: "inFlightColumns")
    }
}
