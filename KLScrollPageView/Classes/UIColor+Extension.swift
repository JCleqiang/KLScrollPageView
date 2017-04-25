//
//  UIColor+Extension.swift
//  KLScrollPageView-Demo
//
//  Created by leqiang222 on 2017/3/25.
//  Copyright © 2017年 静持大师. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1.0)
    }
}

extension UIColor {
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat) {
        guard let com = self.cgColor.components else {
            fatalError("颜色必须 RGB 创建")
        }
        
        return (com[0] * 255, com[1] * 255, com[2] * 255)
    }
}
