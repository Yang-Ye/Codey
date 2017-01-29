//
//  DescriptionCell.swift
//  Codey
//
//  Created by Yang Ye on 11/20/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit

class DescriptionCell: UITableViewCell {
    @IBOutlet var webView: UIWebView!

    override func awakeFromNib() {
        webView.isHidden = true
        webView.tag = 0
        webView.scrollView.tag = 1
    }

    func loadHTML(problem: Problem, realLoad: Bool) {
        if realLoad {
            webView.isHidden = false
        }
        if let htmlFile = Bundle.main.path(forResource: "\(problem.name) source", ofType: "html") {
            if let html = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8) {
                webView.loadHTMLString(html, baseURL: nil)
                return
            }
        }
        webView.loadHTMLString("Sorry, I encounter an error...😳☹️😅💀", baseURL: nil)
    }

}
