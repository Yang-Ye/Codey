//
//  SolutionCell.swift
//  Codey
//
//  Created by Yang Ye on 3/14/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class SolutionCell: UITableViewCell {

    @IBOutlet var customBackgroundView: UIView!
    @IBOutlet var solutionTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.customBackgroundView.layer.cornerRadius = problemDetailViewCornerRadius
        self.contentView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
