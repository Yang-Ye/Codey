//
//  Codey+Uitilities.swift
//  Codey
//
//  Created by Yang Ye on 1/29/17.
//  Copyright © 2017 YY. All rights reserved.
//

import Foundation
import UIKit

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

enum PopPushAnimtaionType: String {
    case Fade = "kCATransitionFade"
    case MoveIn = "kCATransitionMoveIn"
    case Push = "kCATransitionPush"
    case Reveal = "kCATransitionReveal"
}

extension UINavigationController {
    func push(controller: UIViewController, type: PopPushAnimtaionType, direction: String, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = type.rawValue
        transition.subtype = direction
        self.view.layer.add(transition, forKey: nil)
        self.pushViewController(controller, animated: false)
    }

    func pop(type: PopPushAnimtaionType, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = kCATransitionMoveIn
        self.view.layer.add(transition, forKey: nil)
        _ = self.popViewController(animated: false)
    }
}

extension UIView {

    var x: CGFloat {
        get {
            return self.frame.origin.x
        }

        set {
            self.frame = CGRect(x: newValue, y: self.y, width: self.width, height: self.height)
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        }

        set {
            self.frame = CGRect(x: self.x, y: newValue, width: self.width, height: self.height)
        }
    }

    var position: CGPoint {
        get {
            return CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
        }

        set {
            self.frame = CGRect(x: position.x, y: position.y, width: self.width, height: self.height)
        }

    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        }

        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.height)
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }

        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.width, height: newValue)
        }
    }

    var size: CGSize {
        get {
            return CGSize(width: self.frame.size.width, height: self.frame.size.height)
        }

        set {
            self.frame = CGRect(x: self.x, y: self.y, width: size.width, height: size.height)
        }
    }
}

extension UIAlertController {
    static func simpleAlert(title: String?, message: String?) -> UIAlertController {
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        return alert
    }
}

extension UIImage {
    static func hardnessIconFromHardness(hardness: Int) -> UIImage {
        if hardness == 0 {
            return #imageLiteral(resourceName: "easyIcon")
        } else if hardness == 1 {
            return #imageLiteral(resourceName: "mediumIcon")
        } else {
            return #imageLiteral(resourceName: "hardIcon")
        }
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

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }

}
