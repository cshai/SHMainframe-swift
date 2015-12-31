//
//  SHViewControllerExtension .swift
//  SHViewFramewrokForQQ1
//
//  Created by Sam on 15/12/16.
//  Copyright © 2015年 Sam. All rights reserved.
//

import UIKit

internal enum  SHViewControllerExtensionEventNotificationName: String {
    case Pan = "ViewControllerMainFramePanGestureRecognizer"
    case Tap = "ViewControllerMainFrameTapGestureRecognizer"
}

public extension UIViewController {
    
    //MARK: - 添加处理滑动手势
    
    /**
    添加拖拽手势响应，给需要处理响应的UIViewController调用
    */
    public func addMainFramePanGestureRecognizer()
    {
        let pan = UIPanGestureRecognizer.init(target: self, action: "mainFramePanGestureRecognizer:")
        self.view.addGestureRecognizer(pan);
    }
    
    /**
     处理拖拽手势
     */
    internal func mainFramePanGestureRecognizer(sender: UIPanGestureRecognizer)
    {
        var dic = Dictionary<String,AnyObject>();
        dic["panGestureRecognizer"] = sender
        NSNotificationCenter.defaultCenter().postNotificationName(SHViewControllerExtensionEventNotificationName.Pan.rawValue, object:self, userInfo:dic)
    }
    
    //MARK: - 添加处理点击手势
    
    /**
    表示事件屏蔽tapView的唯一Tag
    */
    internal static var tapViewTag:NSInteger {
        return 15000
    }
    
    /**
     添加点击手势
     */
    public func addOnceMainFrameTapGestureRecognizer()
    {
        let view = UIView(frame: self.view.bounds)
        view.tag = UIViewController.tapViewTag;
        //添加点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: "mainFrameTapGestureRecognizer:")
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap);
        //代理拖动事件
        let pan = UIPanGestureRecognizer.init(target: self, action: "onceViewPanGestureRecognizer:")
        self.view.addGestureRecognizer(pan);
        
        self.view.addSubview(view)
    }
    
    /**
     处理点击手势
     */
    internal func mainFrameTapGestureRecognizer(sender: UITapGestureRecognizer)
    {
        var dic = Dictionary<String,AnyObject>();
        dic["tapGestureRecognizer"] = sender
        NSNotificationCenter.defaultCenter().postNotificationName(SHViewControllerExtensionEventNotificationName.Tap.rawValue, object:self, userInfo:dic)
        self.view.viewWithTag(UIViewController.tapViewTag)?.removeFromSuperview()
    }
    
    /**
     处理代理的拖拽手势
     */
    internal func onceViewPanGestureRecognizer(sender: UIPanGestureRecognizer)
    {
        if (sender.state == UIGestureRecognizerState.Ended)
        {
            self.view.viewWithTag(UIViewController.tapViewTag)?.removeFromSuperview()
        }
        var dic = Dictionary<String,AnyObject>();
        dic["panGestureRecognizer"] = sender
        NSNotificationCenter.defaultCenter().postNotificationName(SHViewControllerExtensionEventNotificationName.Pan.rawValue, object:self, userInfo:dic)
    }
}














