//
//  CodeyUITabBarController.swift
//  Codey
//
//  Created by Yang Ye on 3/10/17.
//  Copyright © 2017 YY. All rights reserved.
//

import UIKit

class CodeyUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.black
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tabBar.barTintColor = UIColor.white
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
