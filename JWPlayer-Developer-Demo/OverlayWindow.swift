//
//  OverlayWindow.swift
//  WolfCore
//
//  Created by Wolf McNally on 2/9/17.
//  Copyright © 2017 Arciem. All rights reserved.
//

import UIKit

private var _overlayWindow: OverlayWindow?
public var overlayWindow: OverlayWindow! {
    get {
        if _overlayWindow == nil {
            _overlayWindow = OverlayWindow()
        }
        return _overlayWindow
    }

    set {
        _overlayWindow = newValue
    }
}

public var overlayView: UIView {
    return overlayWindow!.subviews[0] as! UIView
}

public func removeOverlayWindow() {
    overlayWindow = nil
}

public class OverlayWindow: UIWindow {
    public init() {
        super.init(frame: .zero)
        _setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }
    
    public func __setup() {
        translatesAutoresizingMaskIntoConstraints = false
        makeTransparent()
    }
    
    public func makeTransparent() {
        isOpaque = false
//        normalBackgroundColor = .clear
    }
    
    private func _setup() {
        __setup()

        windowLevel = UIWindowLevelAlert + 100
        frame = UIScreen.main.bounds
        rootViewController = OverlayViewController()
        //        show()
        isHidden = false
        setup()
    }

    open func setup() { }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        return isTransparentToTouch(at: point, with: event)
        return true
    }
}

public class OverlayViewController: UIViewController {
    public override func loadView() {
        let v = UIView()
//        v.isTransparentToTouches = true
        v.translatesAutoresizingMaskIntoConstraints = true
        v.isOpaque = false
        v.backgroundColor = UIColor.clear
        
        //let v2 = UIView()
        //v2.backgroundColor = UIColor.green
        //v.addSubview(v2)
        
        view = v
        
    }
    
    public override func viewDidLoad() {
        
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        view.makeTransparent()
        
    }
}
