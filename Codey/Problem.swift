//
//  Problem.swift
//  Code
//
//  Created by Yang Ye on 11/6/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Problem: NSManagedObject{
    @NSManaged var name: String
    @NSManaged var tags: [String]
    @NSManaged var company: [String]
    @NSManaged var hardness: Hardness
    @NSManaged var isStared: Bool
    @NSManaged var isSolved: Bool
    @NSManaged var searchName: String
    @NSManaged var isHot: Bool
    @NSManaged var order: Int
    @NSManaged var timeStarred: Date?
    @NSManaged var note: String?
    @NSManaged var lastEditNote: Date?
}

extension Problem {
    var themeColor: UIColor {
        switch hardness {
        case .easy:
            return UIColor.greenFlatDark
        case .medium:
            return UIColor.orangeFlatDark
        case .hard:
            return UIColor.redFlat
        }
    }

    var hasNote: Bool {
        if let _ = self.note {
            return true
        }
        return false
    }
}
