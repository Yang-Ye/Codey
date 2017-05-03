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

    var dimmingView: DimmingView = DimmingView()

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.bounds.insetBy(dx: 0, dy: containerView!.height / 4).offsetBy(dx: 0, dy: containerView!.height / 4)
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        self.dimmingView.frame = containerView!.bounds
    }

    override func presentationTransitionWillBegin() {
        let containerView = self.containerView
        let presentedVC = self.presentedViewController
        dimmingView.frame = containerView!.bounds
        dimmingView.backgroundColor = UIColor.black
        dimmingView.alpha = 0.0

        containerView?.insertSubview(dimmingView, at: 0)

        presentedVC.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0.5
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0.0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
}
