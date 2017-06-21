//
//  ProblemsTableView.swift
//  Code
//
//  Created by Yang Ye on 11/3/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let problemCellHeight: CGFloat = 50.0
let headerFloatingViewHeight: CGFloat = 35
let goldPoint: CGFloat = 1.618

enum ScrollDirection {
    case up
    case down
}

class ProblemTableViewController: UIViewController, RefineViewControllerDelegate {

    let codey = CodeyManger.sharedInstance
    var previousScrollViewOffset: CGFloat = 0.0

    @IBOutlet var headerFloatingView: HeaderFloatingView!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!

    var headerHeight = headerFloatingViewHeight
    var headerFloatingViewWasHiding = false
    var viewFirstAppear = true

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.barTintColor = codey.themeColor
        self.setupTableView()
        self.setupSearchBar()

        self.view.addSubview(self.headerFloatingView)
        self.headerFloatingView.leftButton.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        self.headerFloatingView.rightButton.addTarget(self, action: #selector(pickOneAction), for: .touchUpInside)
        self.headerFloatingView.title.text = "\(self.codey.problems.count)"
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.headerViewHeightConstraint.constant = headerFloatingViewHeight
        tableView.reloadData()
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.headerFloatingView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: headerFloatingViewHeight)

        if headerFloatingViewWasHiding {
            self.hideHeadFloatingView(animation: false)
        } else {
            self.displayHeaderFloatingView(animation: false)
        }
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupSearchBar() {
        let searchBar = UISearchController(searchResultsController: nil).searchBar
        searchBar.delegate = self
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.backgroundColor = UIColor.hexStringToUIColor(hex: "e8e8e8")
        searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
    }

    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        self.tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()

        let view = ProblemTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.width, height: headerFloatingViewHeight))
        self.tableView.tableHeaderView = view
    }

    func pickOneAction() {
        let randomNum = Int(arc4random_uniform(UInt32(self.codey.problems.count)))
        self.navigationController?.pushViewController(ProblemDetailViewController(problem: self.codey.problems[randomNum]), animated: true)
    }

    func filterAction() {
        let refineVC = RefineViewController()
        refineVC.delegate = self
        let naviPvc = UINavigationController(rootViewController: refineVC)
        self.present(naviPvc, animated: true, completion: nil)
    }

    func applyButtonTapped() {
        DispatchQueue.doThis(onBackGroundQ: {
            if self.codey.hasSelectedKeys {
                self.codey.problems = self.codey.problemsConstant
            } else {
                self.codey.problems = self.codey.problemsConstant.filter({ problem -> Bool in
                    let hardness = self.codey.selectedKeys[0]
                    let tags = self.codey.selectedKeys[1]
                    let companies = self.codey.selectedKeys[2]

                    var flag = true
                    if hardness.count != 0 {
                        flag = flag && hardness.contains(self.codey.hardnessString(hardness: problem.hardness))
                    }

                    if tags.count != 0 {
                        flag = flag && (tags.intersection(Set(problem.tags)).count > 0)
                    }

                    if companies.count != 0 {
                        flag = flag && (companies.intersection(Set(problem.company)).count > 0)
                    }
                    return flag
                })
            }
        }, onMainQ: {
            self.headerFloatingView.title.text = "\(self.codey.problems.count)"
            self.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        })
    }

    func getViewControllerWithId(id: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.headerFloatingView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: headerFloatingViewHeight)
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension ProblemTableViewController: UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codey.problems.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(problemCellHeight)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell", for: indexPath) as! ProblemCell
        let problem = codey.problems[indexPath.row]
        cell.problemName.text = problem.name
        cell.isStared.isHidden = !problem.isStared
        cell.hardnessIcon.image = UIImage.hardnessIconFromHardness(hardness: problem.hardness.rawValue)
        cell.isHot.isHidden = !problem.isHot
        cell.selectionStyle = .none
        cell.order.text = "\(problem.order)"

        let sgr = UISwipeGestureRecognizer(target: self, action: #selector(cellSwiped(_:)))
        sgr.direction = .right

        let sgl = UISwipeGestureRecognizer(target: self, action: #selector(cellSwiped(_:)))
        sgr.direction = .left

        cell.addGestureRecognizer(sgr)
        cell.addGestureRecognizer(sgl)

        return cell
    }

    func cellSwiped(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended, let cell = gestureRecognizer.view as? ProblemCell, let indexPath = self.tableView.indexPath(for: cell) {
            if gestureRecognizer.direction == .right {
                let problem = codey.problems[indexPath.row]
                if problem.isStared {
                    problem.isStared = false
                    codey.starredProblems.remove(codey.problems[indexPath.row])
                } else {
                    problem.isStared = true
                    problem.timeStarred = Date()
                    codey.starredProblems.insert(codey.problems[indexPath.row])
                }
                cell.isStared.isHidden = !problem.isStared
            } else if gestureRecognizer.direction == .left {
                let pvc = AddToListTableViewController(style: .plain)
                pvc.problem = codey.problems[indexPath.row]

                let pvcNavigationVC = UINavigationController(rootViewController: pvc)
                pvcNavigationVC.modalPresentationStyle = UIModalPresentationStyle.custom
                pvcNavigationVC.transitioningDelegate = self

                self.present(pvcNavigationVC, animated: true, completion:nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var problem: Problem!
        problem = self.codey.problems[indexPath.row]
        let problemDetailVC = ProblemDetailViewController(problem: problem)
        self.navigationController?.pushViewController(problemDetailVC, animated: true)
    }

    func hideHeadFloatingView(animation: Bool = true) {
        if animation {
            UIView.animate(withDuration: 0.2) {
                self.headerFloatingView.y = -headerFloatingViewHeight
            }
        } else {
            self.headerFloatingView.y = -headerFloatingViewHeight
        }
    }

    func displayHeaderFloatingView(animation: Bool = true) {
        if self.headerFloatingView.y != 0 {
            if animation {
                UIView.animate(withDuration: 0.2) {
                    self.headerFloatingView.y = 0
                }
            } else {
                self.headerFloatingView.y = 0
            }
        }
    }

    

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if codey.lists.count == 0 {
//                self.present(UIAlertController.simpleAlert(title: nil, message: "You don't have any lists."), animated: true, completion:nil)
//                return
//            }
//
//            let pvc = AddToListTableViewController(style: .plain)
//            pvc.problem = codey.problems[indexPath.row]
//
//            let pvcNavigationVC = UINavigationController(rootViewController: pvc)
//            pvcNavigationVC.modalPresentationStyle = UIModalPresentationStyle.custom
//            pvcNavigationVC.transitioningDelegate = self
//
//            self.present(pvcNavigationVC, animated: true, completion:nil)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "Add to List"
//    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollSpeed = scrollView.contentOffset.y - previousScrollViewOffset
        previousScrollViewOffset = scrollView.contentOffset.y

        if scrollView.contentOffset.y > 0 {
            if scrollSpeed > 0 {
                var newY = headerFloatingView.y - scrollSpeed/goldPoint
                newY = max(newY, -headerFloatingView.height)
                headerFloatingView.y = newY
            }
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.displayHeaderFloatingView()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.displayHeaderFloatingView()
    }

    func presentationController(forPresented presented: UIViewController, presenting:
        UIViewController?, source: UIViewController) -> UIPresentationController? {
        let halfSizePresentationVC =  HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
        halfSizePresentationVC.dimmingView.touchedAction = {self.dismiss(animated: true, completion: nil)}
        return halfSizePresentationVC
    }
}

extension ProblemTableViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchReslutVC = SearchResultTableViewController(style: .plain)
        let navi = UINavigationController(rootViewController: searchReslutVC)
        navi.modalPresentationStyle = .custom
        navi.modalTransitionStyle = .crossDissolve
        self.present(navi, animated: true, completion: nil)
        return false
    }
}
