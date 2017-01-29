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
import MBProgressHUD

let problemCellHeight = 65

enum SortType {
    case number
    case alphabetic
    case easyToHard
    case hardToEasy

    func next() -> SortType {
        switch self {
        case .number: return .alphabetic
        case .alphabetic: return .easyToHard
        case .easyToHard: return .hardToEasy
        case .hardToEasy: return .number
        }
    }
}

class ProblemTableViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, RefineViewControllerDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filter: UIBarButtonItem!
    @IBOutlet var sort: UIBarButtonItem!
    let codey = CodeyManger.sharedInstance
    var currentSortType: SortType = .alphabetic

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(codey.problemPool.count)"
        self.navigationController?.navigationBar.barTintColor = codey.themeColor
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = codey.themeColor
        self.setupTableView()
    }

    func setupTableView() {
        self.tableView.separatorColor = UIColor.gray
        self.tableView.separatorInset = .zero
        self.tableView.register(UINib.init(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        self.tableView.backgroundColor = UIColor.white
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codey.problemPool.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(problemCellHeight)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell", for: indexPath) as! ProblemCell
        let problem = codey.problemPool[indexPath.row]
        cell.problemName.text = problem.name
        cell.problemHardness.text = codey.hardnessString(hardness: problem.hardness)
        cell.problemHardness.textColor = problem.themeColor
        cell.isStared.isHidden = !problem.isStared
        cell.isHot.isHidden = !problem.isHot
        cell.selectionStyle = .none
        cell.order.text = "\(problem.order)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let problem = self.codey.problemPool[indexPath.row]
        let problemDetailVC = ProblemDetailViewController(problem: problem)
        self.navigationController?.pushViewController(problemDetailVC, animated: true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global().async {
            self.codey.problemPool = self.codey.problems.filter { (problem) -> Bool in
                if searchText == "" {
                    return true
                }
                return problem.searchName.contains(searchText.lowercased())
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func pickOneAction(_ sender: Any) {
        let randomNum = Int(arc4random_uniform(UInt32(self.codey.problems.count)))
        self.navigationController?.pushViewController(ProblemDetailViewController(problem: self.codey.problems[randomNum]), animated: true)
    }

    @IBAction func filterAction(_ sender: UIBarButtonItem) {
        let refineVC = RefineViewController()
        refineVC.delegate = self
        let naviPvc = UINavigationController(rootViewController: refineVC)
        self.present(naviPvc, animated: true, completion: nil)
    }

    func applyButtonTapped() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        DispatchQueue.doThis(onBackGroundQ: {
            if self.codey.hasSelectedKeys {
                self.codey.problemPool = self.codey.problems
            } else {
                self.codey.problemPool = self.codey.problems.filter({ problem -> Bool in
                    let hardness = self.codey.selectedKeys[0]
                    let tags = self.codey.selectedKeys[1]
                    let companies = self.codey.selectedKeys[2]

                    var flag = true
                    if hardness.count != 0 {
                        flag = flag && hardness.contains(self.hardnessString(hardness: problem.hardness))
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
            self.navigationItem.title = "\(self.codey.problemPool.count)"
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    func hardnessString(hardness: Int) -> String {
        if hardness == 0 {
            return "Easy"
        } else if hardness == 1 {
            return "Medium"
        } else {
            return "Hard"
        }
    }

    func getViewControllerWithId(id: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}
