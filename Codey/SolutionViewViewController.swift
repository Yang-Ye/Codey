//
//  SolutionViewViewController.swift
//  Codey
//
//  Created by Yang Ye on 3/16/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class SolutionViewViewController: UIViewController {

    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.cornerRadius = problemDetailViewCornerRadius
        self.view.backgroundColor = CodeyManger.tableViewBackgroundColor()

        let fontPlus = UIBarButtonItem(image: #imageLiteral(resourceName: "font-fill"), style: .plain, target: self, action: #selector(changeFontBig))

        let fontMinus = UIBarButtonItem(image: #imageLiteral(resourceName: "fontM"), style: .plain, target: self, action: #selector(changeFontSmall))

        navigationItem.rightBarButtonItems = [fontPlus, fontMinus]
    }

    func changeFontBig() {
        CodeyManger.soluionFontSize = CodeyManger.soluionFontSize.next
        self.textView.font = UIFont.init(name: "Courier", size:(CodeyManger.solutionTextViewFontSize()))
    }

    func changeFontSmall() {
        CodeyManger.soluionFontSize = CodeyManger.soluionFontSize.previous
        self.textView.font = UIFont.init(name: "Courier", size:(CodeyManger.solutionTextViewFontSize()))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadHTML(type: HTMLType, problem: Problem) {
        DispatchQueue.global().async {
            if let htmlFilePath = Bundle.main.path(forResource: "\(problem.name) \(type.rawValue)", ofType: "html") {
                if let html = try? String(contentsOfFile: htmlFilePath, encoding: String.Encoding.utf8), let data = html.data(using: .utf8), let attributedHTMLString = try? NSAttributedString.init(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil) {
                    DispatchQueue.main.async {
                        self.textView.attributedText = attributedHTMLString
                        self.textView.font = UIFont.init(name: "Courier", size:(CodeyManger.solutionTextViewFontSize()))
                    }
                }
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { coordinator in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrientationChageNotification"), object: nil, userInfo: ["height":self.view.height])
        })
    }
}
