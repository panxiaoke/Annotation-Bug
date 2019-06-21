//
//  FxColor.swift
//  FxCommon
//
//  Created by Fang on 2017/7/3.
//  Copyright © 2017年 Byron. All rights reserved.
//

import UIKit

public extension UIColor {
    /// 根据 RGB 值生成颜色 eg: UIColor(red: 46, green: 169, blue: 223, alpha: 1.0)
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    /// 根据 Hex 值生成颜色 eg: UIColor(hex: 0x2ea9df)
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func rgbToColor(r: Int, g: Int, b: Int, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    static func colorWithHexString(hex:String, alpha: CGFloat = 1) ->UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    // 白色背景的 rgba -> rgb 反推
    static func rgba2rgb(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor {
        let tR = CGFloat(r) / 255.0
        let tG = CGFloat(g) / 255.0
        let tB = CGFloat(b) / 255.0
        let sR = (tR - (1.0-a)) / a
        let sG = (tG - (1.0-a)) / a
        let sB = (tB - (1.0-a)) / a
        return UIColor(red: sR, green: sG, blue: sB, alpha: 1)
    }
    
    // 默认的导航栏透明度为 0.855
    static let fxNavbar = UIColor.rgba2rgb(r: 46, g: 169, b: 223, a: 0.855)  // 导航栏颜色
    //  static let fxNavbar = UIColor.colorWithHexString(hex:"#0999DA")       // 导航栏颜色
    static let fxClear = UIColor.clear                    //< clear
    static let fxWhite = UIColor.white                    //< 白色
    static let fxBlack = UIColor.colorWithHexString(hex:"#545a64")            //< 正常黑色
    static let fxDeepBlack = UIColor.colorWithHexString(hex:"#212121")        //< 深黑色
    static let fxLittleBlack = UIColor.colorWithHexString(hex:"#606060")      //< 浅一点的黑色
    static let fxGray = UIColor.colorWithHexString(hex:"#909090")             //< 灰色
    static let fxLittleGray = UIColor.colorWithHexString(hex:"#acb2c1")      //<  浅灰色
    static let fxGrayPurple = UIColor.colorWithHexString(hex: "#a8b3d3")      //< 灰紫色
    static let fxBlue = UIColor.rgbColor(46, 169, 223)                        //< 蓝色
    static let fxDeepBlue = UIColor.colorWithHexString(hex: "#1485B7")        //< 深蓝色
    static let fxDDppBlue = UIColor.colorWithHexString(hex: "#0b6ed3")        //< 深深深的蓝色
    static let fxPaleBlue = UIColor.colorWithHexString(hex: "#96d4ef")        //< 淡淡的蓝色
    static let fxDeepPaleBlue = UIColor.colorWithHexString(hex: "#259dd1")    //< 淡淡的蓝色在深一点
    static let fxDarkGreyBlue = UIColor.colorWithHexString(hex: "#253448")
    static let fxDodgerBlue = UIColor.colorWithHexString(hex: "#41a2ff")
    static let fxRed = UIColor.colorWithHexString(hex: "#e36251")             //< 红色
    static let fxNavRed = UIColor.colorWithHexString(hex: "#fe3131")          //< 赠金导航栏红色
    static let fxRedSystem = UIColor.red                  //< 系统红色
    static let fxRedNotice = UIColor.colorWithHexString(hex: "#ff3b36")       //< 通知红色
    static let fxOrange = UIColor.colorWithHexString(hex: "#eb887b")          //< 粉红色
    static let fxGreen = UIColor.colorWithHexString(hex: "#72d465")           //< 绿色
    static let fxGreenSub = UIColor.colorWithHexString(hex: "#43B591")        //< 反正带点绿
    static let fxDeepGreen = UIColor.colorWithHexString(hex: "#44a989")       //< 深绿色
    static let fxYellow = UIColor.colorWithHexString(hex: "#f6B322")          //< 黄色
    static let fxPaleYellow = UIColor.colorWithHexString(hex: "#fbe1a7")      //< 淡淡的黄色
    static let fxOrangYellow = UIColor.colorWithHexString(hex: "#f68322")     //< 橙黄色
    static let fxBackGround = UIColor.colorWithHexString(hex: "#f7f7f8")      //< 背景色(table)
    static let fxChatBackGround = UIColor.colorWithHexString(hex: "#ebebeb")  //< 聊天页面的背景色 16-08-20
    static let fxGrayWhiteBottom = UIColor.colorWithHexString(hex: "#f7f7f7") //< 底部菜单灰白色
    static let fxGrayWhite = UIColor.colorWithHexString(hex: "#f6f6f7")       //< 灰白 cell按下去颜色
    static let fxPaleGray = UIColor.colorWithHexString(hex: "#cccccc")        //< 浅灰色
    static let fxGrayGreen = UIColor.colorWithHexString(hex: "#ff0000")       //< 灰绿
    static let fxGrayYellow = UIColor.colorWithHexString(hex: "#fffaef")      //< 灰黄
    static let fxCoolGrey = UIColor.colorWithHexString(hex: "#8c909b")
    static let fxLine = UIColor.colorWithHexString(hex: "#F0F0F0")            //< 分割线
    static let fxBtnHighlighted = UIColor.colorWithHexString(hex: "#13749E")  //< button 按下去颜色
    static let fxOverhead = UIColor.colorWithHexString(hex: "#FFFDF4")        //< 聊天列表顶置颜色
    static let fxForeMallDetailBottom = UIColor.colorWithHexString(hex: "#7ac1ec")    //< 聊天列表顶置颜色
    static let fxBonusYellow = UIColor.colorWithHexString(hex: "#f4cb6d")      //<赠金 发送的黄色 YES
    static let fxBonusYellowAlpha = UIColor.colorWithHexString(hex: "#99f4cb") //<赠金 发送的黄色 NO
    static let fxBonusRed = UIColor.colorWithHexString(hex: "#ea5e2c")         //<赠金 发送的红色
    static let fxDarkSeafoam = UIColor.colorWithHexString(hex: "#20b77c")      //< 牛人榜 绿色
    static let fxDarkPeach = UIColor.colorWithHexString(hex: "#eb7863")       //< 牛人榜 红色
    static let fxGoldColor = UIColor(red: 203/255.0, green: 180/255.0, blue: 104/255.0, alpha: 1.0)
    // 按钮状态背景颜色
    static let fxButtonNormalColor = UIColor(red: 46/255.0, green: 169/255.0, blue: 223/255.0, alpha: 1.0)
    static let fxButtonDisabledColor = UIColor(red: 46/255.0, green: 169/255.0, blue: 223/255.0, alpha: 0.5)
    static let fxButtonHighlightColor = UIColor(red: 41/255.0, green: 151/255.0, blue: 200/255.0, alpha: 1.0)
    
    static func rgbColor(_ r: Int, _ g: Int, _ b: Int) -> UIColor{
        return UIColor(red: CGFloat(r)/255.0,
                       green: CGFloat(g)/255.0,
                       blue: CGFloat(b)/255.0, alpha: 1)
    }
    
    static func fxTextGray() -> UIColor{
        return UIColor.rgbColor(144, 144, 144)
    }
    
    static func fxTextBlack() -> UIColor{
        return UIColor.rgbColor(48, 48, 48)
    }
    
    static func fxLightBlue() -> UIColor{
        return UIColor.rgbColor(46, 169, 223)
    }
    
    static func fxWhiteGray() -> UIColor{
        return UIColor.rgbColor(246 , 247, 249)
    }
    
    static func fxGraySeperator() -> UIColor{
        return UIColor.rgbColor(221 , 221, 221)
    }
    
    static func fxTableViewHeader() -> UIColor{
        return UIColor.rgbColor(247 , 247, 247)
    }
    
}
