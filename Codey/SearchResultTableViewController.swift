//
//  SearchResultTableViewController
//  Codey
//
//  Created by Yang Ye on 3/7/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {

    var problems:[Problem] = []
    var searchBar: UISearchBar!
    var codey: CodeyManger = CodeyManger.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.tableView.register(UINib.init(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        searchBar = UISearchController(searchResultsController: nil).searchBar
        self.navigationItem.titleView = searchBar
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.backgroundColor = UIColor.hexStringToUIColor(hex: "e8e8e8")
        searchBar.delegate = self
        self.tableView.backgroundColor = CodeyManger.tableViewBackgroundColor()
        self.tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSFontAttributeName : UIFont(name: "ArialRoundedMTBold", size: 15)!], for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    override func viewWillAppear(_ animated: Bool) {
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.problems.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell", for: indexPath) as! ProblemCell
        let problem = self.problems[indexPath.row]

        cell.problemName.text = problem.name
        
        cell.isStared.isHidden = !problem.isStared
        cell.isHot.isHidden = !problem.isHot
        cell.selectionStyle = .none
        cell.order.text = "\(problem.order)"
        cell.hardnessIcon.image = UIImage.hardnessIconFromHardness(hardness: problem.hardness.rawValue)
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
        let problemDetailVC = ProblemDetailViewController(problem: self.problems[indexPath.row])
        self.navigationController?.pushViewController(problemDetailVC, animated: true)
    }

    func keyboardWasShown(_ notification: Notification) {
        if let keyboardSizeValue = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSizeValue.height, 0)
        }
    }
}

extension SearchResultTableViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.configureCancelBarButton()
        return true
    }

    func configureCancelBarButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelSearch))
        self.navigationItem.setRightBarButton(cancelButton, animated: true)
    }

    func cancelSearch() {
        self.searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.problems = []
        } else {
            self.problems = codey.problems.filter({ (problem) -> Bool in
                return problem.searchName.contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
}
