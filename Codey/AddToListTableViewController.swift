//
//  AddToListTableViewController.swift
//  Codey
//
//  Created by Yang Ye on 3/28/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class AddToListTableViewController: UITableViewController {

    let codey = CodeyManger.sharedInstance
    var problem: Problem!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        tableView.separatorStyle = .none
        self.setupNavigationBarItems()
        self.tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }

    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.inList.isHidden = !aList.problems.contains(problem.order)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (codey.lists[indexPath.row].problems).insert(problem.order)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func setupNavigationBarItems() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white

        let leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Delete").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = leftButtonItem

        let rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItem = rightButtonItem
    }

    func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    func addAction() {
        let alertVC = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        alertVC.addTextField {[weak self] textField in
            textField.placeholder = "Please enter a list name"
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
