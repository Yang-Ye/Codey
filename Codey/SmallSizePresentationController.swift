//
//  SmallSizePresentationController.swift
//  Codey
//
//  Created by Yang Ye on 4/23/17.
//  Copyright © 2017 YY. All rights reserved.
//

import Foundation

import Foundation
import UIKit
class SmallSizePresentationController : HalfSizePresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bound: CGRect = containerView!.bounds
        return bound.insetBy(dx: bound.width*1/10, dy: bound.height*1/5).offsetBy(dx: 0, dy: -bound.height*1/10)
    }
}

