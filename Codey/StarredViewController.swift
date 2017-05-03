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
    var emptyLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        self.tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }

    override func viewWillLayoutSubviews() {
        emptyLabel?.frame = CGRect(x: 0, y: tableView.height/3, width: tableView.width, height: 100)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.dataSource = codey.sortedStarredProblems
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
        cell.hardnessIcon.image = UIImage.hardnessIconFromHardness(hardness: problem.hardness.rawValue)
        cell.isStared.isHidden = false
        cell.selectionStyle = .none
        cell.order.text = "\(problem.order)"
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > 0{
            emptyLabel?.removeFromSuperview()
            emptyLabel = nil
        } else if emptyLabel == nil {
            emptyLabel = UILabel(frame: CGRect(x: 0, y: tableView.height/3, width: tableView.width, height: 100 ))
            emptyLabel!.textAlignment = .center
            emptyLabel!.font = UIFont(name: codeyFont, size: CodeyManger.emptyPageInfoSize())
            emptyLabel!.textColor = UIColor.darkGray
            emptyLabel!.text = "You don't have any starred problems."
            tableView.addSubview(emptyLabel!)
        }
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return problemCellHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let problem = self.codey.sortedStarredProblems[indexPath.row]
        let problemDetailVC = ProblemDetailViewController(problem: problem)
        self.navigationController?.pushViewController(problemDetailVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let problem = dataSource[indexPath.row]
            problem.isStared = false
            self.codey.starredProblems.remove(problem)
            self.dataSource.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
