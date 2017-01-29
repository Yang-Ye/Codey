//
//  Problem.swift
//  Code
//
//  Created by Yang Ye on 11/6/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import CoreData

class Problem: NSManagedObject{
    @NSManaged var name: String
    @NSManaged var tags: [String]
    @NSManaged var company: [String]
    @NSManaged var hardness: Int
    @NSManaged var isStared: Bool
    @NSManaged var isSolved: Bool
    @NSManaged var searchName: String
    @NSManaged var isHot: Bool
    @NSManaged var order: Int
}

extension Problem {
    var themeColor: UIColor {
        switch hardness {
        case 0:
            return UIColor.greenFlatDark
        case 1:
            return UIColor.orangeFlatDark
        default:
            return UIColor.redFlat
        }
    }
}
