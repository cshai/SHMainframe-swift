//
//  SHMainFrameViewController.swift
//  SHViewFramewrokForQQ1
//
//  Created by Sam on 15/12/15.
//  Copyright © 2015年 Sam. All rights reserved.
//

import UIKit


public class SHMainframeViewController: UIViewController {
    
    /**
     左边视图控制器最大占据屏幕总宽度的比例
     */
    public var leftViewControllerMaxScaleOfWidth:CGFloat = 0.8 {
        didSet {
            self.leftViewControllerMaxScaleOfWidth = max(0.1, self.leftViewControllerMaxScaleOfWidth)
            self.leftViewControllerMaxScaleOfWidth = min(1.0, self.leftViewControllerMaxScaleOfWidth)
        }
    }
    
    /**
     左边视图控制器刚开始展示的区域起始值占自身总宽度的比例
     */
    public var leftViewControllerStartScaleOfWidth:CGFloat = 0.2 {
        didSet {
            self.leftViewControllerStartScaleOfWidth = max(0.0, self.leftViewControllerStartScaleOfWidth)
            self.leftViewControllerStartScaleOfWidth = min(1.0, self.leftViewControllerStartScaleOfWidth)
        }
    }
    /**
     右边视图控制器移动到最右边时的缩放比例
     */
    public var rigthViewControllerMinScaleSize:(sx:CGFloat,sy:CGFloat) = (1.0,1.0) {
        didSet {
            self.rigthViewControllerMinScaleSize.sx = max(0.1, self.rigthViewControllerMinScaleSize.sx)
            self.rigthViewControllerMinScaleSize.sx = min(1.0, self.rigthViewControllerMinScaleSize.sx)
            self.rigthViewControllerMinScaleSize.sy = max(0.1, self.rigthViewControllerMinScaleSize.sy)
            self.rigthViewControllerMinScaleSize.sy = min(1.0, self.rigthViewControllerMinScaleSize.sy)
            self.leftViewController?.view.frame = CGRectMake(self.leftViewControllerMoveRangeX.min, 0.0, self.view.bounds.width * (2.0 - self.leftViewControllerStartScaleOfWidth), self.view.bounds.height)
        }
    }
    
    /**
     左边视图控制器view的X移动的最小和最大值
     */
    public var leftViewControllerMoveRangeX:(min:CGFloat,max:CGFloat) {
        get {
            let minMoveX = -self.view.frame.width * self.leftViewControllerStartScaleOfWidth
            return (min:minMoveX,max:0.0)
        }
    }
    /**
     右边视图控制器view的X移动的最小和最大值
     */
    public var rigthViewControllerMoveRangeX:(min:CGFloat,max:CGFloat) {
        get {
            let maxMoveX = self.view.frame.width * self.leftViewControllerMaxScaleOfWidth
            return (0.0,maxMoveX)
        }
    }
    
    
    /**
     右边视图控制器
     */
    public var rightViewController:UIViewController? = nil {
        
        didSet {
            oldValue?.removeFromParentViewController();
            oldValue?.view.removeFromSuperview();
            if (self.rightViewController != nil)
            {
                self.view.addSubview(self.rightViewController!.view);
                self.addChildViewController(self.rightViewController!);
                //添加拖拽手势
                self.addMainFramePanGestureRecognizer()
            }
        }
    }
    
    /**
     左边视图控制器
     */
    public var leftViewController:UIViewController? = nil {
        
        didSet {
            oldValue?.removeFromParentViewController();
            oldValue?.view.removeFromSuperview();
            if (self.leftViewController != nil)
            {
                self.view.addSubview(self.leftViewController!.view);
                self.addChildViewController(self.leftViewController!);
            }
        }
    }
    
    /**
     添加通知消息监控
     */
    internal func addNotificationMoniter()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rigthViewControllerPanGestureRecognizer:", name: SHViewControllerExtensionEventNotificationName.Pan.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rigthViewControllerTapGestureRecognizer:", name: SHViewControllerExtensionEventNotificationName.Tap.rawValue, object: nil)
    }
    
    //MARK: - 事件响应
    
    internal var lastMoveX:CGFloat = 0.0
    
    /**
     处理拖拽消息
     */
    internal func rigthViewControllerPanGestureRecognizer(notification:NSNotification)
    {
        let rigthVcRangeX = self.rigthViewControllerMoveRangeX
        let currenX = self.rightViewController!.view.frame.origin.x
        
        let panGestureRecognizer = notification.userInfo!["panGestureRecognizer"] as! UIPanGestureRecognizer;
        let translation = panGestureRecognizer.translationInView(self.view);
        if (panGestureRecognizer.state == UIGestureRecognizerState.Began)
        {
            lastMoveX = 0.0;
        }else if(panGestureRecognizer.state == UIGestureRecognizerState.Changed ){
            let moveOffset = translation.x - lastMoveX
            lastMoveX = translation.x
            var moveX = currenX + moveOffset
            moveX = max(moveX, rigthVcRangeX.min)
            moveX = min(moveX, rigthVcRangeX.max)
            let scaleX = 1.0 - moveX / rigthVcRangeX.max * (1.0 - self.rigthViewControllerMinScaleSize.sx);
            let scaleY = 1.0 - moveX / rigthVcRangeX.max * (1.0 - self.rigthViewControllerMinScaleSize.sy);
            
            self.rightViewController?.view.transform = CGAffineTransformMakeScale(scaleX,scaleY)
            self.rightViewController?.view.frame.origin.x = moveX;
            self.leftViewController?.view.frame.origin.x = leftViewControllerMoveRangeX.min + moveX * self.leftViewControllerStartScaleOfWidth / self.leftViewControllerMaxScaleOfWidth
        }else if (panGestureRecognizer.state == UIGestureRecognizerState.Ended)
        {
            self.openLeftView(currenX >= rigthVcRangeX.max * 0.5, animation: true)
        }
    }
    
    /**
     处理点击事件
     */
    internal func rigthViewControllerTapGestureRecognizer(notification:NSNotification)
    {
        self.openLeftView(false, animation: true)
    }
    
    /**
     回到最初或最终位置
     */
    public func openLeftView(open:Bool, animation:Bool)
    {
        let duration = animation ? 0.15 :0.0
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            if(open){
                self.rightViewController?.view.transform = CGAffineTransformMakeScale(self.rigthViewControllerMinScaleSize.sx, self.rigthViewControllerMinScaleSize.sy)
                self.rightViewController?.view.frame.origin.x = self.rigthViewControllerMoveRangeX.max
                self.leftViewController?.view.frame.origin.x = self.leftViewControllerMoveRangeX.max
                //添加点击事件，这里需要view屏蔽rightview本身的其他事件
                self.rightViewController?.addOnceMainFrameTapGestureRecognizer()
            }else
            {
                self.rightViewController?.view.transform = CGAffineTransformIdentity
                self.rightViewController?.view.frame.origin.x = self.rigthViewControllerMoveRangeX.min
                self.leftViewController?.view.frame.origin.x = self.leftViewControllerMoveRangeX.min
            }
        })
        
    }
}

internal extension SHMainframeViewController {
    
    //MARK: - 方法覆盖
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.addNotificationMoniter()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //初始化位置大小
        self.leftViewController?.view.frame = CGRectMake(self.leftViewControllerMoveRangeX.min, 0.0, self.view.bounds.width * (2.0 - self.leftViewControllerStartScaleOfWidth), self.view.bounds.height)
        self.rightViewController?.view.frame = self.view.bounds
    }
}

