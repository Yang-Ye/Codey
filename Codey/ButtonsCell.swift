//
//  ButtonsCell.swift
//  Codey
//
//  Created by Yang Ye on 11/20/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit

class ButtonsCell: UITableViewCell {
    @IBOutlet var buttons: UISegmentedControl!

    func loadButtonColor(problem: Problem) {
        buttons.tintColor = problem.themeColor
    }

    override func awakeFromNib() {
        buttons.selectedSegmentIndex = 3
    }
}
