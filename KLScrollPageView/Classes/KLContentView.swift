//
//  KLContentView.swift
//  KLScrollPageView-Demo
//
//  Created by leqiang222 on 2017/3/24.
//  Copyright © 2017年 静持大师. All rights reserved.
//

import UIKit

private let kContentCellID = "__contentCellID__"

protocol KLContentViewDelegate: class {
    /// contentView结束滚动
    ///
    /// - parameter contentView: self
    /// - parameter inIndex:      在哪里结束滚动
    func contentView(contentView: KLContentView, didEndScroll inIndex: Int)
    
    
    /// 监听 collectionView 的滚动
    ///
    /// - parameter contentView: <#contentView description#>
    /// - parameter sourceIndex: <#sourceIndex description#>
    /// - parameter targetIndex: <#targetIndex description#>
    /// - parameter progress:
    func contentView(contentView: KLContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

class KLContentView: UIView {
    weak var deleagte: KLContentViewDelegate?
    var isForbidDeleagte = false
    
    var childVCs: [UIViewController]
    var parentVC: UIViewController
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        var temp: UICollectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        
        temp.isPagingEnabled = true
        temp.bounces = false
        temp.showsHorizontalScrollIndicator = false
        temp.backgroundColor = UIColor.white
        
        temp.dataSource = self
        temp.delegate = self
        
        temp.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)

        return temp
    }()
    // 起始偏移量
    var startOffsetX: CGFloat = 0

    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        // 在自定义构造函数调用super.init之前，必须保证所有的属性被初始化，
        // 否则报 Property self.titles not initialized... 错误
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

extension KLContentView {
    fileprivate func setupUI()  {
        for childVC in childVCs {
            parentVC.addChildViewController(childVC)
        }
        
        addSubview(collectionView) 
    }
}

extension KLContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
         
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVC = childVCs[indexPath.item]
        childVC.view.backgroundColor = UIColor.randomColor()
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}

extension KLContentView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        
        if contentOffsetX == startOffsetX || isForbidDeleagte {
            return
        }
        
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        var progress: CGFloat = 0
        let width = collectionView.bounds.size.width
        
        if contentOffsetX > startOffsetX { // 左滑
            sourceIndex = Int(contentOffsetX / width)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count { // $$$
                targetIndex = childVCs.count - 1
            }
            
            progress = (contentOffsetX - startOffsetX) / width
            
            if contentOffsetX - startOffsetX == width { //
                targetIndex = sourceIndex
            }
            
        }else { // 右滑
            targetIndex = Int(contentOffsetX / width)
            sourceIndex = targetIndex + 1
            
            progress = (startOffsetX - contentOffsetX) / collectionView.bounds.size.width
        }
        
//        print("contentOfftX: \(contentOffsetX), progress: \(progress)")
        
        deleagte?.contentView(contentView: self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    // 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDeleagte = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        collectionView.isScrollEnabled = false
    }
    
    
    // 结束拖拽,但还可能有缓冲
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { // 已经没有缓冲了
            scrollDidEndScroll()
        }
    }

    // 结束缓冲
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDidEndScroll()
    }
    
    private func scrollDidEndScroll() {
        collectionView.isScrollEnabled = true
        
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        deleagte?.contentView(contentView: self, didEndScroll: index)
    }
}

// MARK: KLTitleViewDeleagte
extension KLContentView: KLTitleViewDeleagte {
    // 点击标题会调用
    func titleView(titleView: KLTitleView, targetIndex: Int) {
        // 禁止掉执行代理方法
        isForbidDeleagte = true
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at:.left, animated: false)
        
    }
}
