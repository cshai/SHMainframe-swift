//
//  SHRightViewController.swift
//  SHViewFramewrokForQQ1
//
//  Created by Sam on 15/12/15.
//  Copyright © 2015年 Sam. All rights reserved.
//

import UIKit
import SHMainframe

class SHRightViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oneVc = UIViewController()
        let twoVc = UIViewController()
        let threeVc = UIViewController()
        
        oneVc.title = "控制器1"
        twoVc.title = "控制器2"
        threeVc.title = "控制器3"
        
        oneVc.view.backgroundColor = UIColor.redColor()
        twoVc.view.backgroundColor = UIColor.orangeColor()
        threeVc.view.backgroundColor = UIColor.greenColor()
        
        self.addChildViewController(oneVc)
        self.addChildViewController(twoVc)
        self.addChildViewController(threeVc)

    }
    

}


