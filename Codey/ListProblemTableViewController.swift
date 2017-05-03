//
//  ListProblemTableViewController.swift
//  Codey
//
//  Created by Yang Ye on 3/27/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class ListProblemTableViewController: UITableViewController {

    var list:ProblemList!
    let codey = CodeyManger.sharedInstance

    init(list:ProblemList) {
        self.list = list
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.tableView.register(UINib.init(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        self.tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()
        self.tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.problems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell", for: indexPath) as! ProblemCell

        let problemOrder = Array(list.problems)[indexPath.row]
        if let problem = codey.coreData?.fetchProblem(order: problemOrder) {
            cell.problemName.text = problem.name
            cell.hardnessIcon.image = UIImage.hardnessIconFromHardness(hardness: problem.hardness.rawValue)
            cell.isStared.isHidden = !problem.isStared
            cell.isHot.isHidden = !problem.isHot
            cell.selectionStyle = .none
            cell.order.text = "\(problem.order)"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return problemCellHeight
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let problemOrder = Array(list.problems)[indexPath.row]
            self.list.problems.remove(problemOrder)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let problemOrder = Array(list.problems)[indexPath.row]
        if let problem = codey.coreData?.fetchProblem(order: problemOrder) {
            let problemDetailVC = ProblemDetailViewController(problem: problem)
            self.navigationController?.pushViewController(problemDetailVC, animated: true)
        }
    }
}
