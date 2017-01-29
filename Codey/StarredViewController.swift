//
//  AccountViewController.swift
//  Code
//
//  Created by Yang Ye on 11/3/16.
//  Copyright © 2016 YY. All rights reserved.
//

import Foundation
import UIKit

class StarredViewController: UITableViewController {

    var dataSource: [Problem] = []
    let codey = CodeyManger.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = CodeyManger.sharedInstance.themeColor
        self.tableView.separatorColor = UIColor.gray
        self.tableView.separatorInset = .zero
        self.tableView.register(UINib.init(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        self.tableView.backgroundColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        self.dataSource = Array(codey.starredProblems)
        self.tableView.reloadData()
    }

    @IBAction func clearAllStarredProblems(_ sender: Any) {
        let alert = UIAlertController(title: "Clear All", message: "Are you sure to clear all starred problems?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.codey.starredProblems.forEach{ $0.isStared = false }
            self.codey.starredProblems.removeAll()
            self.dataSource.removeAll()
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell", for: indexPath) as! ProblemCell
        let problem = dataSource[indexPath.row]
        cell.problemName.text = problem.name
        cell.problemHardness.text = codey.hardnessString(hardness: problem.hardness)
        cell.problemHardness.textColor = problem.themeColor
        cell.isStared.isHidden = false
        cell.selectionStyle = .none
        cell.order.text = "\(problem.order)"
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(problemCellHeight)
    }
}
