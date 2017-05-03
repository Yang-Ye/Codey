//
//  UIColor+FlatColors.swift
//  Codey
//
//  Created by Yang Ye on 1/16/17.
//  Copyright © 2017 YY. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var cyanFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "1abc9c")
    }

    class var cyanFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "16a085")
    }

    class var greenFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "2ecc71")
    }

    class var greenFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "27ae60")
    }

    class var blueFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "3498db")
    }

    class var blueFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "2980b9")
    }

    class var purpleFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "9b59b6")
    }

    class var purpleFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "8e44ad")
    }

    class var denimFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "34495e")
    }

    class var denimFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "2c3e50")
    }

    class var yellowFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "F9BF3B")
    }

    class var yellowFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "f39c12")
    }

    class var orangeFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "e67e22")
    }

    class var orangeFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "F89406")
    }

    class var redFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "FF3209")
    }

    class var redFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "c0392b")
    }

    class var silverFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "ecf0f1")
    }

    class var silverFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "bdc3c7")
    }

    class var grayFlat: UIColor {
        return UIColor.hexStringToUIColor(hex: "95a5a6")
    }

    class var grayFlatDark: UIColor {
        return UIColor.hexStringToUIColor(hex: "7f8c8d")
    }
}

extension UIColor {
    class func hexStringToUIColor (hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
