//
//  ViewController.swift
//  KLScrollPageView
//
//  Created by leqiang222@163.com on 04/25/2017.
//  Copyright (c) 2017 leqiang222@163.com. All rights reserved.
//

import UIKit
import KLScrollPageView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        self.title = "测试用例"
        
        setupPageView()
    }
    
    func setupPageView() {
        //
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height)
        
        //
        let titles = ["标题一二", "标题二标题二", "标三", "标题四标题四", "标题一题一", "标二", "标题三", "标题", "标题一", "标题二"]
        
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            
            childVCs.append(vc)
        }
        
        //
        let style = KLPageStyle()
        style.titleH = 44 // 默认44
        style.isTitleScollEnable = true
        style.selTitleScale = 1.15
        
        let pageView = KLPageView.init(frame: frame, titles: titles, style: style, childVCs: childVCs, parentVC: self)
        view.addSubview(pageView)
         
    }
}

