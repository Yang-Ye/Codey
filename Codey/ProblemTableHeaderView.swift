//
//  ProblemTableHeaderView.swift
//  Codey
//
//  Created by Yang Ye on 4/9/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class ProblemTableHeaderView: UIView {

    var makeWithLove: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        if let loveLabel = makeWithLove{
            loveLabel.removeFromSuperview()
        }
        makeWithLove = UILabel(frame: rect)
        makeWithLove!.text = "Make with ❤️ by Yang Ye."
        makeWithLove!.font = UIFont(name: "ArialRoundedMTBold", size: 9)
        makeWithLove!.textAlignment = .center
        makeWithLove!.textColor = UIColor.black
        self.addSubview(makeWithLove!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
