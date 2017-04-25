//
//  KLPageView.swift
//  KLScrollPageView-Demo
//
//  Created by leqiang222 on 2017/3/24.
//  Copyright © 2017年 静持大师. All rights reserved.
//

import UIKit

class KLPageView: UIView {
    // 标题
    var titles: [String]
    // 样式
    var style: KLPageStyle
    // 子控制器
    var childVCs: [UIViewController]
    // 父控制器
    var parentVC: UIViewController
    
    //
    init(frame: CGRect, titles: [String], style: KLPageStyle, childVCs: [UIViewController], parentVC: UIViewController) {
        self.titles = titles
        self.style = style
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        //
        super.init(frame: frame)
        
        //
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI 设置
extension KLPageView {
    fileprivate func setupUI()  {
        // 标题
        let titleFram = CGRect.init(x: 0, y: 0, width: bounds.width, height: style.titleH)
        let titleView = KLTitleView.init(frame: titleFram, titles: titles, style: style)
        titleView.backgroundColor = UIColor.white
        
        addSubview(titleView)
        
        // 内容
        let contentFram = CGRect.init(x: 0, y: style.titleH, width: bounds.width, height: bounds.height - style.titleH)
        let contentView = KLContentView.init(frame: contentFram, childVCs: childVCs, parentVC: parentVC)
        contentView.backgroundColor = UIColor.randomColor()
        
        addSubview(contentView)
        
        // 代理
        titleView.delegate = contentView
        contentView.deleagte = titleView
    }
}
