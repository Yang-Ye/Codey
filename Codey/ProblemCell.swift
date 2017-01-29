//
//  ProblemCell.swift
//  Code
//
//  Created by Yang Ye on 11/3/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit

class ProblemCell: UITableViewCell {

    @IBOutlet var problemName: UILabel!
    @IBOutlet var problemHardness: UILabel!
    @IBOutlet var isStared: UIImageView!
    @IBOutlet var isHot: UIImageView!
    @IBOutlet var order: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
    }

    override func awakeFromNib() {
        self.isStared.isHidden = true
        self.isHot.isHidden = true
    }
}

