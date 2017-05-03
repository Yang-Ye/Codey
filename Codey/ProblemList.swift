//
//  ProblemList.swift
//  Codey
//
//  Created by Yang Ye on 3/23/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit
import CoreData

class ProblemList: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var createdDate: Date
    @NSManaged var problems: Set<Int>
}
