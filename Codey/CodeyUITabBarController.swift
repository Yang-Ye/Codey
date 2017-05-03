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
    }

    override func viewWillAppear(_ animated: Bool) {
        self.selectedIndex = 1
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.blueFlat
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
