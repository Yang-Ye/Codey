//
//  TitleCell.swift
//  Codey
//
//  Created by Yang Ye on 3/13/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell,ProblemDetailViewCellProtocol {

    @IBOutlet var title: UILabel!
    @IBOutlet var customBackgroundView: UIView!

    var cellHeight: CGFloat {
        return 30
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.customBackgroundView.layer.cornerRadius = problemDetailViewCornerRadius
        self.contentView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
