//
//  SHTestViewController.swift
//  SHViewFramewrokForQQ1
//
//  Created by Sam on 15/12/30.
//  Copyright © 2015年 Sam. All rights reserved.
//

import UIKit

import SHMainframe

class SHTestMainViewController: SHMainframeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建ViewController
        let leftVc = SHLeftViewController()
        let rigthVc = SHRightViewController()
        
        //设置ViewController
        self.leftViewController = leftVc
        self.rightViewController = rigthVc
        
        //下面可以通过需要调整效果，不设置为默认效果
        
        //设置左边视图控制最大占据屏幕总宽度的比例
        self.leftViewControllerMaxScaleOfWidth = 0.8
        
        //左边视图控制器刚开始展示的区域起始值占自身总宽度的比例
        self.leftViewControllerStartScaleOfWidth = 0.3
        
        //设置右边拖拽时最小缩放比例，默认不缩放
        self.rigthViewControllerMinScaleSize = (0.9,0.9)
    
    }
    
    
}
