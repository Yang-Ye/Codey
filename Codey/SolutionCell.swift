//
//  SolutionCell.swift
//  Codey
//
//  Created by Yang Ye on 11/20/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit

class SolutionCell: UITableViewCell {
    @IBOutlet var webView: UIWebView!

    override func awakeFromNib() {
        webView.tag = 4
        webView.scrollView.tag = 2
    }

    func loadSolution(type: String, problem: Problem) {
        switch type {
        case "java":
            webView.tag = 1
        case "cpp":
            webView.tag = 2
        case "py":
            webView.tag = 3
        default:
            webView.tag = 4
            webView.loadHTMLString("🙈", baseURL: nil)
            return
        }
        if let htmlFile = Bundle.main.path(forResource: "\(problem.name) \(type)", ofType: "html") {
            if let html = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8) {
                webView.loadHTMLString(html, baseURL: nil)
                return
            }
        }
        webView.loadHTMLString("Sorry, I encounter an error...😳☹️😅💀", baseURL: nil)
    }
}
