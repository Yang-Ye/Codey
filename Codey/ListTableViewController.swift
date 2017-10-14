//
//  ListTableViewController.swift
//  Codey
//
//  Created by Yang Ye on 3/25/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

let listHeight: CGFloat = 60

class ListTableViewController: UITableViewController {

    let codey: CodeyManger = CodeyManger.sharedInstance
    var emptyLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        self.tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()
        self.tableView.separatorStyle = .none
        self.navigationController?.navigationBar.barTintColor = .white
    }

    override func viewWillLayoutSubviews() {
        emptyLabel?.frame = CGRect(x: 0, y: tableView.height/3, width: tableView.width, height: 100)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if codey.lists.count > 0{
            emptyLabel?.removeFromSuperview()
            emptyLabel = nil
        } else if emptyLabel == nil {
            emptyLabel = UILabel(frame: CGRect(x: 0, y: tableView.height/3, width: tableView.width, height: 100 ))
            emptyLabel!.textAlignment = .center
            emptyLabel!.font = UIFont(name: codeyFont, size: CodeyManger.emptyPageInfoSize())
            emptyLabel!.textColor = UIColor.darkGray
            emptyLabel!.text = "You don't have any lists."
            tableView.addSubview(emptyLabel!)
        }
        return codey.lists.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.selectionStyle = .none
        let aList = self.codey.lists[indexPath.row]
        cell.name.text = aList.name

        let dateFormator = DateFormatter()
        dateFormator.dateStyle = .short
        cell.date.text = dateFormator.string(from: aList.createdDate)
        cell.problemCount.text = "\(aList.problems.count)"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ListProblemTableViewController.init(list: codey.lists[indexPath.row]) , animated: true)
        
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.codey.coreData?.deleteList(list: self.codey.lists[indexPath.row])
            self.codey.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction func deleteAll(_ sender: Any) {
        let alert = UIAlertController(title: "Clear All", message: "Are you sure to clear all starred problems?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { ( _ ) in
            for list in self.codey.lists {
                self.codey.coreData?.deleteList(list: list)
            }
            self.codey.lists.removeAll()
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }


    @IBAction func addList(_ sender: Any) {
        let alertVC = UIAlertController(title: "Create a new list", message: nil, preferredStyle: .alert)
        alertVC.addTextField {[weak self] textField in
            textField.placeholder = "Please enter a name for the list"
            textField.addTarget(self, action: #selector(self?.alertTextFieldDidChange(_:)), for: .editingChanged)
        }

        let okAction = UIAlertAction(title: "Create", style: .destructive) {[weak self] (action) in
            self?.codey.lists.append((self?.codey.coreData?.makeNewList(name: alertVC.textFields!.first!.text!))!)
            self?.tableView.reloadData()
        }
        okAction.isEnabled = false

        let canelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertVC.addAction(canelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    func alertTextFieldDidChange(_ textfield: UITextField) {
        if let alertController = self.presentedViewController as? UIAlertController {
            let login = alertController.textFields?.first
            let okAction = alertController.actions.last
            okAction?.isEnabled = (login?.text?.characters.count)! > 0
        }
    }
}
