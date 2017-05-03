//
//  SolutionCell.swift
//  Codey
//
//  Created by Yang Ye on 11/20/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit

enum HTMLType: String {
    case source = "source"
    case java = "java"
    case cpp = "cpp"
    case python = "py"
}

class TextViewCell: UITableViewCell,ProblemDetailViewCellProtocol {
    @IBOutlet var textView: UITextView!

    var cellHeight: CGFloat {
        return 300
    }

    override func awakeFromNib() {
        self.textView.layer.cornerRadius = problemDetailViewCornerRadius
        self.contentView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }

    func loadHTML(type: HTMLType, problem: Problem) {
        DispatchQueue.global().async {
            if let htmlFilePath = Bundle.main.path(forResource: "\(problem.name) \(type.rawValue)", ofType: "html") {
                if let html = try? String(contentsOfFile: htmlFilePath, encoding: String.Encoding.utf8), let data = html.data(using: .utf8), let attributedHTMLString = try? NSAttributedString.init(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil) {
                    DispatchQueue.main.async {
                        self.textView.attributedText = attributedHTMLString
                        self.textView.font = UIFont.init(name: "TimesNewRomanPSMT", size:(CodeyManger.textViewCellFontSize()))
                    }
                }
            }
        }
    }
}
