//
//  ListTableViewCell.swift
//  Codey
//
//  Created by Yang Ye on 3/25/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var problemCount: UILabel!
    @IBOutlet var customBackgroundView: UIView!
    @IBOutlet var inList: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.problemCount.text = "0"
        self.customBackgroundView.layer.cornerRadius = problemDetailViewCornerRadius
        self.contentView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }
}
