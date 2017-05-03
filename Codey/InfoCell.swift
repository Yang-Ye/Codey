//
//  InfoCell.swift
//  Codey
//
//  Created by Yang Ye on 2/26/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell, ProblemDetailViewCellProtocol{
    @IBOutlet var customBackgroundView: UIView!
    @IBOutlet var hardness: UILabel!
    @IBOutlet var isHot: UIImageView!

    var cellHeight: CGFloat {
        return 30
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.hardness.font = CodeyManger.titleCellFont()
        self.customBackgroundView.layer.cornerRadius = problemDetailViewCornerRadius
        self.contentView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }
}
