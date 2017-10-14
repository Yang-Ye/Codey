//
//  HeaderFloatingView.swift
//  Codey
//
//  Created by Yang Ye on 3/8/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit
class HeaderFloatingView: UIView {

    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var middleButton: UIButton!

    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
