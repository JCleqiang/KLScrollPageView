//
//  KLPageStyle.swift
//  KLScrollPageView-Demo
//
//  Created by leqiang222 on 2017/3/24.
//  Copyright © 2017年 静持大师. All rights reserved.
//

import UIKit

open class KLPageStyle: NSObject {
    
    /// 标题的高度
    open var titleH: CGFloat = 44
    
    /// 标题未选中颜色
    open var titleNorColor: UIColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    
    /// 标题已选中颜色
    open var titleSelColor: UIColor = UIColor.init(red: 1.0, green: 127.0/255.0, blue: 0, alpha: 1.0)
    
    /// 标题字体
    open var titleFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    /// 标题是否可以滚动
    open var isTitleScollEnable: Bool = false
    
    /// 标题之间的间隔
    open var titleMargin: CGFloat = 20
    
    /// 是否显示底部 line
    open var isShowbottonLine: Bool = true
    
    /// 底部 line 颜色
    open var bottomLineColor: UIColor = UIColor.red
    
    /// 底部 line 高度
    open var bottomLineH: CGFloat = 2
    
    /// 选中的字体比例，默认和未选中的一样
    open var selTitleScale: CGFloat = 1.0
}
