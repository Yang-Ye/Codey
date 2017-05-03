//
//  RefineCellCollectionViewCell.swift
//  Codey
//
//  Created by Yang Ye on 1/28/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class RefineCell: UICollectionViewCell {
    @IBOutlet var background: UIView!
    @IBOutlet var title: UILabel!
    var select: Bool = false

    override func awakeFromNib() {
        self.backgroundColor = UIColor.white
        self.isSelected = false
        background.layer.cornerRadius = 8
    }
}
