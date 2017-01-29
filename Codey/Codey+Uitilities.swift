//
//  Codey+Uitilities.swift
//  Codey
//
//  Created by Yang Ye on 1/29/17.
//  Copyright © 2017 YY. All rights reserved.
//

import Foundation

extension UIButton {
    static func buttonWithImage(image: UIImage) -> UIButton {
        let image = image.withRenderingMode(.alwaysTemplate)
        let iconSize = CGRect(origin: CGPoint.zero, size: image.size)
        let iconButton = UIButton(frame: iconSize)
        iconButton.setImage(image, for: .normal)
        iconButton.tintColor = UIColor.white
        return iconButton
    }
}

extension DispatchQueue {
    class func doThis(onBackGroundQ action1: @escaping () -> Void, onMainQ action2: @escaping () -> Void) {
        self.global().async {
            action1()
            self.main.async {
                action2()
            }
        }
    }
}

extension UINavigationController {
    func push(controller: UIViewController, type: String, direction: String, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = type
        transition.subtype = direction
        self.view.layer.add(transition, forKey: nil)
        self.pushViewController(controller, animated: false)
    }
}

func ==(lhs: [[String]], rhs: [[String]]) -> Bool {
    if lhs.count == rhs.count {
        for index in 0...lhs.count-1 {
            if lhs[index] != rhs[index] {
                return false
            }
        }
        return true
    }
    return false
}
