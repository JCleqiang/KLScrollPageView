//
//  KLTitleView.swift
//  KLScrollPageView-Demo
//
//  Created by leqiang222 on 2017/3/24.
//  Copyright © 2017年 静持大师. All rights reserved.
//

import UIKit

protocol KLTitleViewDeleagte: class {
    
    /// 标题选中后调用
    ///
    /// - parameter titleView:   self
    /// - parameter targetIndex: 选中的索引
    func titleView(titleView: KLTitleView, targetIndex: Int)
}

class KLTitleView: UIView {
    // 代理
    weak var delegate: KLTitleViewDeleagte?
    // 标题普通颜色
    fileprivate lazy var norRGB: (CGFloat, CGFloat, CGFloat) = self.style.titleNorColor.getRGBValue()
    // 标题选中颜色
    fileprivate lazy var selRGB: (CGFloat, CGFloat, CGFloat) = self.style.titleSelColor.getRGBValue()
    // 颜色差值
    fileprivate lazy var dltRGB: (CGFloat, CGFloat, CGFloat) = {
        let r = self.selRGB.0 - self.norRGB.0
        let g = self.selRGB.1 - self.norRGB.1
        let b = self.selRGB.2 - self.norRGB.2
        
        return (r, g, b)
    }()
    // 标题数据
    fileprivate var titles: [String]
    // 样式
    fileprivate var style: KLPageStyle
    //
    fileprivate lazy var scrollView: UIScrollView = {
        let temp = UIScrollView.init(frame: self.bounds)
        temp.showsHorizontalScrollIndicator = false
        temp.scrollsToTop = false
        
        return temp
    }()
    // 标题 label
    fileprivate lazy var labels = [UILabel]()
    // 底部线
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    // 当前选中的索引
    fileprivate var curIndex: NSInteger = 0
    
    //
    init(frame: CGRect, titles: [String], style: KLPageStyle) { 
        self.titles = titles
        self.style = style 
        
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 设置 UI
extension KLTitleView {
    fileprivate func setupUI() {
        //
        addSubview(scrollView)
        
        // 创建标题 label
        setupTitleLabels()
        
        // 底部下划线
        if style.isShowbottonLine {
            setupBottomLine()
        }
    }
    
    // 创建标题 label
    private func setupTitleLabels() {
        for i in 0..<titles.count {
            let label = UILabel()
            
            label.tag = i
            label.text = titles[i]
            label.textAlignment = .center
            label.textColor = (i == 0) ? style.titleSelColor : style.titleNorColor
            label.font = style.titleFont
            label.isUserInteractionEnabled = true
            
            scrollView.addSubview(label)
            
            labels.append(label)
            
            //
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(labelTap))
            label.addGestureRecognizer(tap)
            
            // 
            var labelW: CGFloat = bounds.width / CGFloat(titles.count)
            let labelH: CGFloat = style.titleH
            var labelX: CGFloat = 0
            let labelY: CGFloat = 0
            
            // 设置 label 的 fram
            if style.isTitleScollEnable { // 如果设置的是标题能滚动
                let size = CGSize.init(width: CGFloat(MAXFLOAT), height: labelH)
                
                labelW = (label.text! as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: style.titleFont], context: nil).width as CGFloat
                labelX = i == 0 ? style.titleMargin * 0.5 : labels[i - 1].frame.maxX + style.titleMargin
                
            }else {
                labelX = CGFloat(i) * labelW
            }
            
            label.frame = CGRect.init(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        if style.isTitleScollEnable {
            scrollView.contentSize = CGSize.init(width: labels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }else {
            scrollView.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: 0)
        }
        
        if style.selTitleScale != 1.0 { // 选中文字字体大小
            labels.first?.transform = CGAffineTransform(scaleX: style.selTitleScale, y: style.selTitleScale)
        }
    }
    
    // 底部下划线
    private func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        
        bottomLine.frame.size.height = style.bottomLineH
        bottomLine.frame.size.width = labels.first!.frame.size.width
        bottomLine.frame.origin.x = labels.first!.frame.origin.x
        bottomLine.frame.origin.y = style.titleH - style.bottomLineH
    }
}

// MARK: - label 点击事件
extension KLTitleView {
    func labelTap(tap: UITapGestureRecognizer) {
        guard let targetLabel = tap.view as? UILabel else { // 目的 label
            return
        }
        
        if targetLabel.tag == curIndex {
            return
        }
        
        let sourceLabel = labels[curIndex] // 源 label
        
        //
        sourceLabel.textColor = style.titleNorColor
        targetLabel.textColor = style.titleSelColor
        
        //
        curIndex = targetLabel.tag
    
        // 
        updateContentOffset(targetLabel: targetLabel)
        
        // 通知代理
        // 可选链: 如果可选类型有值, 才执行
        delegate?.titleView(titleView: self, targetIndex: curIndex)
    
        let dur: TimeInterval = 0.2
        
        //
        if style.selTitleScale != 1.0 {
            UIView.animate(withDuration: dur, delay: 0, options: .curveEaseInOut, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.selTitleScale, y: self.style.selTitleScale)
                
                }, completion: nil)
        }

        // 
        if style.isShowbottonLine {
            UIView.animate(withDuration: dur, delay: 0, options: .curveEaseInOut, animations: {
                self.bottomLine.frame.size.width = targetLabel.bounds.width * self.style.selTitleScale
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
            
            }, completion: nil)
        }
    }
    
    func updateContentOffset(targetLabel: UILabel) {
        var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if offsetX > maxOffsetX  {
            offsetX = maxOffsetX
        }
        
        print("llq: \(offsetX)")
        
        scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
}

// MARK: KLContentViewDelegate
extension KLTitleView: KLContentViewDelegate {
    // contentView正在滚动调用该方法
    func contentView(contentView: KLContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        let sourceLabel: UILabel = labels[sourceIndex]
        let targetLabel = labels[targetIndex]
        
        // 颜色渐变
        sourceLabel.textColor = UIColor.init(red: (selRGB.0 - dltRGB.0 * progress) / 255.0,
                                             green: (selRGB.1 - dltRGB.1 * progress) / 255.0,
                                             blue: (selRGB.2 - dltRGB.2 * progress) / 255.0,
                                             alpha: 1.0)
        targetLabel.textColor = UIColor.init(red: (norRGB.0 + dltRGB.0 * progress) / 255.0,
                                             green: (norRGB.1 + dltRGB.1 * progress) / 255.0,
                                             blue: (norRGB.2 + dltRGB.2 * progress) / 255.0,
                                             alpha: 1.0)
        
        //
        if style.selTitleScale != 1.0 {
            let deltaScal = style.selTitleScale - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.selTitleScale - deltaScal * progress, y: style.selTitleScale - deltaScal * progress)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScal * progress, y: 1.0 + deltaScal * progress)
        }
        
        // 
        if style.isShowbottonLine {
            let deltaW = targetLabel.bounds.width - sourceLabel.bounds.width
            bottomLine.frame.size.width = (sourceLabel.bounds.width + deltaW * progress) * style.selTitleScale
            
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
        }
    }
    
    // contentView结束滚动调用该方法
    func contentView(contentView: KLContentView, didEndScroll inIndex: Int) {
        curIndex = inIndex
        let targetLabel = labels[inIndex]
        
        updateContentOffset(targetLabel: targetLabel)
    }
}
