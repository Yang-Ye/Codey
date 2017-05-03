//
//  MoreTableViewController.swift
//  Codey
//
//  Created by Yang Ye on 4/9/17.
//  Copyright © 2017 YY. All rights reserved.
//

import Foundation
import UIKit

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        tableView.register(UINib.init(nibName: "MoreTableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MoreTableHeaderView")
        tableView.register(UINib.init(nibName: "MoreTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreTableViewCell")
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MoreTableHeaderView") as! MoreTableHeaderView
        var text: String!
        switch section {
        case 0:
            text = "Version"
        case 1:
            text = "Credits"
        case 2:
            text = "blah 1"
        case 3:
            text = "blah 2"
        default:
            text = "blah 3"
        }
        header.headViewText.text = text
        return header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell") as! MoreTableViewCell
        return cell
    }
}
