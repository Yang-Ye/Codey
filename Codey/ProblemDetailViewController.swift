//
//  ProblemDetailViewController.swift
//  Code
//
//  Created by Yang Ye on 11/9/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit
import WebKit

let initNameHeight:CGFloat = 30.0
let initDescriptionHeight: CGFloat = 30.0
let initButtonsHeight: CGFloat = 50.0
let initSolutionHeight: CGFloat = 30.0

enum SelectedSolution: Int {
    case java = 0
    case cpp = 1
    case py = 2
    case hide = 3

    func toStringType() -> String {
        switch self {
        case .java:
            return "java"
        case .cpp:
            return "cpp"
        case .py:
            return "py"
        default:
            return "hide"
        }
    }
}

class ProblemDetailViewController: UITableViewController, UIWebViewDelegate {
    var problem: Problem!
    var descriptionCell: DescriptionCell!
    var solutionCell: SolutionCell!
    var currentSelectedSolution: SelectedSolution = .hide
    var buttonCell: ButtonsCell?
    var heightDict: [CGFloat] = [initNameHeight, initDescriptionHeight, initButtonsHeight, initSolutionHeight]
    var heightloaded: [String: Bool] = ["desc": false, "solu": false]

    init(problem: Problem) {
        super.init(nibName: nil, bundle: nil)
        self.problem = problem
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidDisappear(_ animated: Bool) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        tableView.register(UINib.init(nibName: "ButtonsCell", bundle: nil), forCellReuseIdentifier: "ButtonsCell")
        tableView.register(UINib.init(nibName: "SolutionCell", bundle: nil), forCellReuseIdentifier: "SolutionCell")
        tableView.register(UINib.init(nibName: "NameCell", bundle: nil), forCellReuseIdentifier: "NameCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
            cell.textLabel?.numberOfLines = 1;
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.text = problem.name
            cell.textLabel?.textAlignment = NSTextAlignment.center
            return cell
        case 1:
            let cell: DescriptionCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            cell.webView.delegate = self
            cell.webView.scrollView.delegate = self
            cell.loadHTML(problem: problem, realLoad: heightloaded["desc"]!)
            descriptionCell = cell
            return cell
        case 2:
            let cell: ButtonsCell = tableView.dequeueReusableCell(withIdentifier: "ButtonsCell", for: indexPath) as! ButtonsCell
            cell.loadButtonColor(problem: problem)
            cell.buttons.addObserver(self, forKeyPath: "selectedSegmentIndex", options: NSKeyValueObservingOptions([.new, .old]), context: nil)
            buttonCell = cell
            return cell
        default:
            let cell: SolutionCell  = tableView.dequeueReusableCell(withIdentifier: "SolutionCell", for: indexPath) as! SolutionCell
            cell.webView.delegate = self
            cell.webView.scrollView.delegate = self
            cell.loadSolution(type: currentSelectedSolution.toStringType(), problem: problem)
            solutionCell = cell
            return cell
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightDict[indexPath.row]
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = CodeyManger.sharedInstance.themeColor
        setupNavigationBarItems()
    }

    func setupNavigationBarItems() {
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        let rotateButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "rotate"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rotateSelf))
        rotateButtonItem.tintColor = UIColor.black

        let backButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(popSelf))
        backButtonItem.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = backButtonItem

        let starButton: UIButton!
        if !problem.isStared {
            starButton = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "star2"))
        } else {
            starButton = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "star3"))
        }
        starButton.addTarget(self, action: #selector(starSelf), for: UIControlEvents.touchUpInside)
        starButton.tintColor = UIColor.black
        let starButtonItem = UIBarButtonItem(customView: starButton)
        navigationItem.rightBarButtonItems = [starButtonItem, rotateButtonItem]
    }

    func popSelf() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func starSelf() {
        if !problem.isStared {
            problem.isStared = true
            CodeyManger.sharedInstance.starredProblems.insert(problem)

            let button = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "star3"))
            button.tintColor = UIColor.black
            button.addTarget(self, action: #selector(self.starSelf), for: UIControlEvents.touchUpInside)
            self.navigationItem.rightBarButtonItems?[0].customView = button
        } else {
            problem.isStared = false
            CodeyManger.sharedInstance.starredProblems.remove(problem)

            let button = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "star2"))
            button.tintColor = UIColor.black
            button.addTarget(self, action: #selector(self.starSelf), for: UIControlEvents.touchUpInside)
            self.navigationItem.rightBarButtonItems?[0].customView = button
        }
    }

    func rotateSelf() {
        if tableView.frame.size.width <  tableView.frame.size.height {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        } else {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.tag == 0 {
            if heightloaded["desc"] == false {
                heightloaded["desc"] = true
                heightDict[1] = webView.scrollView.contentSize.height
                tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: UITableViewRowAnimation.fade)
            }
        } else {
            if heightloaded["solu"] == false {
                heightloaded["solu"] = true
                if webView.tag == 4 {
                    heightDict[3] = 40.0
                } else {
                    heightDict[3] = webView.scrollView.contentSize.height
                }
                tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: UITableViewRowAnimation.fade)
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectedSegmentIndex" {
            if let object = object as? UISegmentedControl {
                if  object.selectedSegmentIndex != currentSelectedSolution.rawValue {
                    heightloaded["solu"] = false
                    switch object.selectedSegmentIndex {
                    case 0:
                        currentSelectedSolution = .java
                    case 1:
                        currentSelectedSolution = .cpp
                    case 2:
                        currentSelectedSolution = .py
                    default:
                        currentSelectedSolution = .hide
                    }
                    tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: UITableViewRowAnimation.fade)
                }
            }
        }
    }

    deinit {
        buttonCell?.buttons.removeObserver(self, forKeyPath: "selectedSegmentIndex")
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { coordinator in
            self.tableView.reloadData()
        })
    }
}

