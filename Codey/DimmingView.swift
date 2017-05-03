//
//  DimmingView.swift
//  Codey
//
//  Created by Yang Ye on 3/28/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class DimmingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var touchedAction: (()->Void)?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let action = self.touchedAction {
            action()
        }
    }
}
