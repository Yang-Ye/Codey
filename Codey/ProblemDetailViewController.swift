//
//  ProblemDetailViewController.swift
//  Code
//
//  Created by Yang Ye on 11/9/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit

enum SelectedSolution: Int {
    case java = 0
    case cpp = 1
    case py = 2

    func toStringType() -> String {
        switch self {
        case .java:
            return "java"
        case .cpp:
            return "cpp"
        case .py:
            return "py"
        }
    }
}

enum ProblemDetailViewCellHeightRatio: CGFloat {
    case info = 0.2
    case source = 0.80
}

enum ModelAuxView {
    case addToList
    case addNote
}

let problemDetailViewCornerRadius: CGFloat = 2.0

protocol ProblemDetailViewCellProtocol {
    var cellHeight: CGFloat { get }
}

class ProblemDetailViewController: UITableViewController, UITextViewDelegate, UIViewControllerTransitioningDelegate {
    var problem: Problem!
    var viewHeight: CGFloat = 0.0
    var codey: CodeyManger = CodeyManger.sharedInstance
    var firstLoaded: Bool = true
    var auxModalView: ModelAuxView = .addToList

    init(problem: Problem) {
        super.init(nibName: nil, bundle: nil)
        self.problem = problem
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = .white
        tableView.register(UINib.init(nibName: "TextViewCell", bundle: nil), forCellReuseIdentifier: "TextViewCell")
        tableView.register(UINib.init(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        tableView.register(UINib.init(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib.init(nibName: "TagCell", bundle: nil), forCellReuseIdentifier: "TagCell")
        tableView.register(UINib.init(nibName: "SolutionCell", bundle: nil), forCellReuseIdentifier: "SolutionCell")
        tableView.register(UINib.init(nibName: "SolutionCellLandscape", bundle: nil), forCellReuseIdentifier: "SolutionCellLandscape")
        tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        setupNavigationBarItems()

        viewHeight = self.tableView.bounds.height - (self.navigationController?.navigationBar.frame.size.height ?? 0)

        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: NSNotification.Name(rawValue: "OrientationChageNotification"), object: nil)
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: TitleCell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
            cell.title.text = problem.name
            cell.title.font = CodeyManger.titleCellFont()
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell: InfoCell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            cell.hardness.text = problem.hardness.stringValue
            cell.hardness.textColor = problem.themeColor
            cell.isHot.isHidden = true
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell: TextViewCell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! TextViewCell
            cell.loadHTML(type: .source, problem: problem)
            cell.selectionStyle = .none
            return cell
        default:
            let orientation = UIApplication.shared.statusBarOrientation
            if  orientation == .landscapeLeft || orientation == .landscapeRight {
                let cell: SolutionCellLandscape = tableView.dequeueReusableCell(withIdentifier: "SolutionCellLandscape", for: indexPath) as! SolutionCellLandscape
                cell.javaButton.addTarget(self, action: #selector(pushJavaSolution), for: .touchUpInside)
                cell.cppButton.addTarget(self, action: #selector(pushCppSolution), for: .touchUpInside)
                cell.pythonButton.addTarget(self, action: #selector(pushPythonSolution), for: .touchUpInside)
                cell.selectionStyle = .none
                let font = CodeyManger.solutionCellFont()
                cell.javaButton.titleLabel?.font = font
                cell.cppButton.titleLabel?.font = font
                cell.pythonButton.titleLabel?.font = font
                return cell
            } else {
                let cell: SolutionCell = tableView.dequeueReusableCell(withIdentifier: "SolutionCell", for: indexPath) as! SolutionCell
                switch indexPath.row {
                case 3:
                    cell.solutionTitle.text = "Java Solution"
                case 4:
                    cell.solutionTitle.text = "C++ Solution"
                default:
                    cell.solutionTitle.text = "Python Solution"
                }
                cell.solutionTitle.font = CodeyManger.solutionCellFont()
                cell.selectionStyle = .none
                return cell
            }
        }
    }

    func pushSolutionWithType(type: HTMLType, title: String) {
        let solutionViewController = SolutionViewViewController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(solutionViewController, animated: true)
        solutionViewController.navigationItem.title = title
        solutionViewController.loadHTML(type: type, problem: self.problem)
    }

    func pushJavaSolution() {
        self.pushSolutionWithType(type: .java, title: "Java")
    }

    func pushCppSolution() {
        self.pushSolutionWithType(type: .cpp, title: "C++")
    }

    func pushPythonSolution() {
        self.pushSolutionWithType(type: .python, title: "Python")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let orientation = UIApplication.shared.statusBarOrientation
        if  orientation == .landscapeLeft || orientation == .landscapeRight {
            return 4
        }
        return 6
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let orientation = UIApplication.shared.statusBarOrientation
        if  orientation == .landscapeLeft || orientation == .landscapeRight {
            switch indexPath.row {
            case 0: return viewHeight * 4.5/40
            case 1: return viewHeight * 4.5/40
            case 2: return viewHeight * 5.3/8
            default: return viewHeight * 4.5/40
            }
        }

        switch indexPath.row {
        case 0: return viewHeight * 3/40
        case 1: return viewHeight * 3/40
        case 2: return viewHeight * 5/8
        default: return viewHeight * 3/40
        }
    }

    func setupNavigationBarItems() {
        self.navigationController?.navigationBar.tintColor = .black

        let starButton: UIButton!
        if !problem.isStared {
            starButton = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "Christmas_Star"))
        } else {
            starButton = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "Christmas_Star_Filled"))
        }
        starButton.addTarget(self, action: #selector(starSelf), for: UIControlEvents.touchUpInside)
        starButton.tintColor = UIColor.black
        let starButtonItem = UIBarButtonItem(customView: starButton)

        let tagButton: UIButton = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "tag"))
        tagButton.addTarget(self, action: #selector(tags), for: UIControlEvents.touchUpInside)
        tagButton.tintColor = UIColor.black
        let tagButtonItem = UIBarButtonItem(customView: tagButton)

        let listButton: UIButton = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "add"))
        listButton.addTarget(self, action: #selector(lists), for: UIControlEvents.touchUpInside)
        listButton.tintColor = UIColor.black
        let listButtonItem = UIBarButtonItem(customView: listButton)

        let noteButton: UIButton = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "pencil"))
        noteButton.addTarget(self, action: #selector(takeNote), for: UIControlEvents.touchUpInside)
        noteButton.tintColor = UIColor.black
        let noteButtonItem = UIBarButtonItem(customView: noteButton)
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = 25
        
        let dismissButton: UIButton = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "Delete"))
        dismissButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        dismissButton.tintColor = .black
        let dismissButtonItem = UIBarButtonItem(customView: dismissButton)
        
        navigationItem.rightBarButtonItems = [starButtonItem, spaceItem, noteButtonItem, spaceItem, listButtonItem, spaceItem, tagButtonItem]
        navigationItem.leftBarButtonItem = dismissButtonItem
    }
    
    func dismissSelf() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orientation = UIApplication.shared.statusBarOrientation
        if  orientation == .landscapeLeft || orientation == .landscapeRight {
            return
        }

        if indexPath.row == 3 {
            self.pushJavaSolution()
        } else if indexPath.row == 4 {
            self.pushCppSolution()
        } else if indexPath.row == 5 {
            self.pushPythonSolution()
        }
    }

    func starSelf() {
        if !problem.isStared {
            problem.isStared = true
            problem.timeStarred = Date()
            CodeyManger.sharedInstance.starredProblems.insert(problem)

            let button = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "Christmas_Star_Filled"))
            button.tintColor = UIColor.black
            button.addTarget(self, action: #selector(self.starSelf), for: UIControlEvents.touchUpInside)
            self.navigationItem.rightBarButtonItems?[0].customView = button
        } else {
            problem.isStared = false
            CodeyManger.sharedInstance.starredProblems.remove(problem)

            let button = UIButton.buttonWithImage(image: #imageLiteral(resourceName: "Christmas_Star"))
            button.tintColor = UIColor.black
            button.addTarget(self, action: #selector(self.starSelf), for: UIControlEvents.touchUpInside)
            self.navigationItem.rightBarButtonItems?[0].customView = button
        }
    }

    func lists() {
        auxModalView = .addToList
        let pvc = AddToListTableViewController(style: .plain)
        pvc.problem = self.problem

        let pvcNavigationVC = UINavigationController(rootViewController: pvc)
        pvcNavigationVC.modalPresentationStyle = UIModalPresentationStyle.custom
        pvcNavigationVC.transitioningDelegate = self

        self.present(pvcNavigationVC, animated: true, completion:nil)
    }

    func takeNote() {
        auxModalView = .addNote
        let pvc = NoteViewController()
        pvc.problem = self.problem

        let pvcNavigationVC = UINavigationController(rootViewController: pvc)
        pvcNavigationVC.modalPresentationStyle = UIModalPresentationStyle.custom
        pvcNavigationVC.transitioningDelegate = self

        self.present(pvcNavigationVC, animated: true, completion:nil)
    }

    func presentationController(forPresented presented: UIViewController, presenting:
        UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch auxModalView {
        case .addToList:
            let halfSizePresentationVC =  HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
            halfSizePresentationVC.dimmingView.touchedAction = {self.dismiss(animated: true, completion: nil)}
            return halfSizePresentationVC
        default:
            let halfSizePresentationVC =  SmallSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
            halfSizePresentationVC.dimmingView.touchedAction = {self.dismiss(animated: true, completion: nil)}
            return halfSizePresentationVC
        }
    }

    func tags() {
        var tagsMessage = ""
        if self.problem.tags.count > 0 {
            tagsMessage = self.problem.tags.reduce("") { $0 + $1 + ", "}
        }
        if self.problem.company.count > 0 {
            tagsMessage = tagsMessage + self.problem.company.reduce("") { $0 + $1 + ", "}
        }
        let alertView = UIAlertController(title: "Tags", message: tagsMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: { coordinator in
            if let naviHeight = self.navigationController?.navigationBar.frame.height {
                self.viewHeight = self.tableView.bounds.height - naviHeight
            }
            
            if UIApplication.shared.statusBarOrientation == .portrait {
                self.viewHeight = self.viewHeight - UIApplication.shared.statusBarFrame.height
            }
            self.tableView.reloadData()
        })
    }

    func orientationDidChange(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            if let height = userInfo["height"] as? CGFloat {
                if let naviHeight = self.navigationController?.navigationBar.frame.height {
                    self.viewHeight = height - naviHeight
                }
                
                if UIApplication.shared.statusBarOrientation == .portrait {
                    self.viewHeight = self.viewHeight - UIApplication.shared.statusBarFrame.height
                }
            }
        }
    }
}
