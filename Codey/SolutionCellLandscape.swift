//
//  SolutionCellLandscape.swift
//  Codey
//
//  Created by Yang Ye on 3/18/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class SolutionCellLandscape: UITableViewCell {

    @IBOutlet var customBackgroundView: UIView!
    @IBOutlet var javaButton: UIButton!
    @IBOutlet var cppButton: UIButton!
    @IBOutlet var pythonButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.customBackgroundView.layer.cornerRadius = problemDetailViewCornerRadius
        self.contentView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }
}
