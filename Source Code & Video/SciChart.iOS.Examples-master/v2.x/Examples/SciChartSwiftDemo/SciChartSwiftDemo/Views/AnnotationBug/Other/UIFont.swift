//
//  FxFont.swift
//  FxCommon
//
//  Created by Fang on 2017/7/3.
//  Copyright © 2017年 Byron. All rights reserved.
//

import UIKit

@objc extension UIFont {
  static let fxTitle =  UIFont.systemFont(ofSize: 15)
  static let fxSubTitle =  UIFont.systemFont(ofSize: 13)
  static let fxRemark =  UIFont.systemFont(ofSize: 11)

  // 导航栏标题font
  static let fxNavgationTitle =  UIFont.boldSystemFont(ofSize: 19)
  static let fxEight =  UIFont.systemFont(ofSize: 8)
  static let fxTen =  UIFont.systemFont(ofSize: 10)
  static let fxTwelve =  UIFont.systemFont(ofSize: 12)
  static let fxThirteen =  UIFont.systemFont(ofSize: 13)
  static let fxFourteen =  UIFont.systemFont(ofSize: 14)
  static let fxFifteen =  UIFont.systemFont(ofSize: 15)
  static let fxSixteen =  UIFont.systemFont(ofSize: 16)
  static let fxSevenTeen =  UIFont.systemFont(ofSize: 17)
  static let fxEightteen =  UIFont.systemFont(ofSize: 18)
  static let fxEleven =  UIFont.systemFont(ofSize: 11)
  static let fxTwoFive =  UIFont.systemFont(ofSize: 25)
  static let fxTwenty =  UIFont.systemFont(ofSize: 20)
  static let fxTwentyOne =  UIFont.systemFont(ofSize: 21)
  static let fxThirtySix =  UIFont.systemFont(ofSize: 36)
  static let fxNameBold =  UIFont.boldSystemFont(ofSize: 16)
  static let fxContentBold =  UIFont.boldSystemFont(ofSize: 14)
  static let fxBoldTwelve =  UIFont.boldSystemFont(ofSize: 12)
  static let fxBoldThirteen =  UIFont.boldSystemFont(ofSize: 13)
  static let fxBoldFourteen =  UIFont.boldSystemFont(ofSize: 14)
  static let fxBoldFifteen =  UIFont.boldSystemFont(ofSize: 15)
  static let fxBoldSixteen =  UIFont.boldSystemFont(ofSize: 16)
  static let fxBoldSeventeen =  UIFont.boldSystemFont(ofSize: 17)
  static let fxBoldEighteen =  UIFont.boldSystemFont(ofSize: 18)
  static let fxBoldTwentyOne =  UIFont.boldSystemFont(ofSize: 21)
  static let fxBoldTwentySeven =  UIFont.boldSystemFont(ofSize: 27)
    
    private static let regularFace = "PingFangSC-Regular"
    private static let mediumFace = "PingFangSC-Medium"
    private static let boldFace = "PingFangSC-bold"
    
    static private var regular: [CGFloat: UIFont] = [:]
    static private var medium: [CGFloat: UIFont] = [:]
    static private var bold: [CGFloat: UIFont] = [:]
    
    static func regularFont(of size: CGFloat)-> UIFont{
        if let font = regular[size] {
            return font
        }
        let font = UIFont(name: regularFace, size: size) ?? UIFont.systemFont(ofSize: size)
        regular[size] = font
        return font
    }
    static func mediumFont(of size: CGFloat) -> UIFont {
        if let font = medium[size] {
            return font
        }
        let font = UIFont(name: mediumFace, size: size) ?? UIFont.systemFont(ofSize: size)
        medium[size] = font
        return font
    }
    
    static func boldFont(of size: CGFloat) -> UIFont {
        if let font = bold[size] {
            return font
        }
        let font = UIFont(name: boldFace, size: size) ?? UIFont.systemFont(ofSize: size)
        bold[size] = font
        return font
    }
}

extension UIFont {
    /// 平方常规
    static func PingFangSC(size: CGFloat) -> UIFont?{
        return  UIFont(name: "PingFang SC", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    /// 平方中粗
    static func PingFangSCMedium(size: CGFloat) -> UIFont?{
        return  UIFont(name: "PingFangSC-Medium", size: size)
    }
    
    /// PingFangSC-Bold
    static func PingFangSCBold(size: CGFloat) -> UIFont?{
        return  UIFont(name: "PingFangSC-Bold", size: size)
    }
    
    /// PingFangSC-Semibold
    static func PingFangSCSemibold(size: CGFloat) -> UIFont? {
        return  UIFont(name: "PingFangSC-Semibold", size: size)
    }
    
    /// PingFangSC-Light
    static func PingFangSCLight(size: CGFloat) -> UIFont? {
        return  UIFont(name: "PingFangSC-Light", size: size)
    }
}

// MARK: fettemittelschriftregular 字体
extension UIFont {
    /// FetteMittelschrift-Regular
    static func fetteMittelschrift(size: CGFloat) -> UIFont{
        return  UIFont(name: "FetteMittelschrift-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
