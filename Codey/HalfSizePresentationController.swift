//
//  HalfSizePresentationController.swift
//  Codey
//
//  Created by Yang Ye on 12/17/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit
class HalfSizePresentationController : UIPresentationController {

    var dimmingView: UIView? = nil

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: containerView!.bounds.height/2, width: containerView!.bounds.width, height: containerView!.bounds.height/2)
    }

    override func presentationTransitionWillBegin() {
        let containerView = self.containerView
        let presentedVC = self.presentedViewController
        dimmingView = UIView(frame: (containerView?.bounds)!)
        dimmingView?.backgroundColor = UIColor.black
        dimmingView?.alpha = 0.0

        containerView?.insertSubview(dimmingView!, at: 0)

        presentedVC.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView?.alpha = 0.5
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView?.alpha = 0.0
        }, completion: nil)
    }
}
