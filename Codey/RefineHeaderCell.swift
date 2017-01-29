//
//  RefineHeaderCell.swift
//  Codey
//
//  Created by Yang Ye on 1/28/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class RefineHeaderCell: UICollectionReusableView {
    @IBOutlet var text: UILabel!

    override func awakeFromNib() {
        self.text.textColor = UIColor.black
    }
}
