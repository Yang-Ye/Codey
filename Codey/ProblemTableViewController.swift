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

enum SortingState {
    case number
    case reverseNumber
    case Alphabet
}

class ProblemTableViewController: UIViewController, RefineViewControllerDelegate {

    let codey = CodeyManger.sharedInstance
    var previousScrollViewOffset: CGFloat = 0.0
    var sortingState: SortingState = .number
    @IBOutlet var headerFloatingView: HeaderFloatingView!

    var headerHeight = headerFloatingViewHeight
    var headerFloatingViewWasHiding = false
    var viewFirstAppear = true

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        let whiteView = UIView(frame: .init(x: 0, y: -50, width: 3000, height: 50))
        whiteView.backgroundColor = .white
        self.navigationController?.navigationBar.addSubview(whiteView)
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.barTintColor = codey.themeColor
        self.setupTableView()
        self.setupSearchBar()

        self.headerFloatingView.leftButton.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        self.headerFloatingView.rightButton.addTarget(self, action: #selector(pickOneAction), for: .touchUpInside)
        self.headerFloatingView.middleButton.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: NSNotification.Name("PDPDismissed"), object: nil)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.headerFloatingView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: headerFloatingViewHeight)
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func updateTableView() {
        self.tableView.reloadData()
    }

    func setupSearchBar() {
        let searchBar = UISearchController(searchResultsController: nil).searchBar
        searchBar.delegate = self
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.backgroundColor = UIColor.hexStringToUIColor(hex: "e8e8e8")
        searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
        
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }

    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        self.tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()
        self.tableView.contentInset = UIEdgeInsetsMake(headerFloatingViewHeight, 0, 0, 0)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
    }

    func pickOneAction() {
        let randomNum = Int(arc4random_uniform(UInt32(self.codey.problems.count)))
        self.presentProblemDetailViewController(problem: self.codey.problems[randomNum])
    }

    func filterAction() {
        let refineVC = RefineViewController()
        refineVC.delegate = self
        let naviPvc = UINavigationController(rootViewController: refineVC)
        self.present(naviPvc, animated: true, completion: nil)
    }
    
    func sortAction() {
        if self.sortingState == .number {
            self.codey.problems.sort { (p1, p2) -> Bool in
                return p1.order > p2.order
            }
            self.sortingState = .reverseNumber
        } else if self.sortingState == .reverseNumber {
            self.codey.problems.sort { (p1, p2) -> Bool in
                return p1.name < p2.name

            }
            self.sortingState = .Alphabet
        } else if self.sortingState == .Alphabet {
            self.codey.problems.sort { (p1, p2) -> Bool in
                return p1.order < p2.order
            }
            self.sortingState = .number
        }
        self.tableView.reloadData()
    }

    func applyButtonTapped() {
        DispatchQueue.doThis(onBackGroundQ: {
            if !self.codey.hasSelectedKeys {
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
            if self.codey.hasSelectedKeys {
                self.headerFloatingView.leftButton.setTitleColor(UIColor.redFlat, for: .normal)
            } else {
                self.headerFloatingView.leftButton.setTitleColor(UIColor.darkGray, for: .normal)
            }
            self.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        })
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
        self.presentProblemDetailViewController(problem: self.codey.problems[indexPath.row])
    }
    
    func presentProblemDetailViewController(problem: Problem) {
        let problemDetailVC = ProblemDetailViewController(problem: problem)
        let navigationController = UINavigationController(rootViewController: problemDetailVC)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
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
