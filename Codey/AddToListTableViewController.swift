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
    var emptyLabel: UILabel?

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
        cell.inList.isHidden = !aList.problems.contains(problem.order)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = codey.lists[indexPath.row]
        if !codey.lists[indexPath.row].problems.contains(problem.order) {
            list.problems.insert(problem.order)
            self.presentAlertWithMessage(message: "Added to list \(list.name)")
        } else {
            list.problems.remove(problem.order)
            self.presentAlertWithMessage(message: "Removed from list \(list.name)")
        }
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func presentAlertWithMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func setupNavigationBarItems() {
        self.navigationController?.navigationBar.barTintColor = .white

        let leftButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Delete").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(cancelAction))
        navigationItem.leftBarButtonItem = leftButtonItem
        let rightButtonItem = UIBarButtonItem(title: "Create a list", style: .done, target: self, action: #selector(addAction))
        rightButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = rightButtonItem
    }

    func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    func addAction() {
        let alertVC = UIAlertController(title: "Create a list", message: nil, preferredStyle: .alert)
        alertVC.addTextField {[weak self] textField in
            textField.placeholder = "Please enter a name for the list."
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
