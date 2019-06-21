//
//  ForexEditAlertView.swift
//  QuickRun
//
//  Created by bailun on 2019/6/6.
//  Copyright © 2019 bailun. All rights reserved.
//

enum ForexEditAlertViewType {
    case confirm
    case input
}

import UIKit

enum ForexEditAlertErrorType {
    case noneContent // 空内容
    case upWordLimit // 超过字数限制
    
}


class ForexEditAlertView: UIView {
    var inputText: String? {
        get {
             return contentView.inputText
        }
        set {
            contentView.inputText = newValue
        }
        
    }
    var sureHandler: ((ForexEditAlertView) -> Void)?
    var cancelHandler: ((ForexEditAlertView) -> Void)?
    var errorHandler: ((ForexEditAlertErrorType) -> Void)? = nil {
        didSet {
            self.contentView.errorHandler = errorHandler
        }
    }
    
    var type: ForexEditAlertViewType = .confirm
    lazy var contentView: ForexEditAlertContentView = {
        var view: ForexEditAlertContentView!
        switch type {
        case .confirm:
            view = ForexEditAlertConfirmView()
        case .input:
            view = ForexEditAlertInputView()
        }
        view.cancelHandler = { [weak self] (sender) in
            guard let self = self else {
                return
            }
            self.dismiss()
            self.cancelHandler?(self)
        }
        view.sureHandler = { [weak self] (sender) in
            guard let self = self else {
                return
            }
            self.dismiss()
            self.sureHandler?(self)
        }
        view.backgroundColor = .white
        view.layer.cornerRadius = 7.0
        return view
    }()

    init(type: ForexEditAlertViewType) {
        self.type = type
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.rgbToColor(r: 0, g: 0, b: 0, a: 0.5)
    }
    
    func showContentView() {
        addSubview(self.contentView)
        
        switch type {
        case .confirm:
            self.contentView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        case .input:
            self.contentView.snp.makeConstraints { (make) in
                make.top.equalTo(20)
                make.centerX.equalToSuperview()
            }
        }
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.1, 0.35, 0.6, 0.85, 1.0]
        animation.duration = 0.25
        animation.isRemovedOnCompletion = false
        self.contentView.layer.add(animation, forKey: "ani")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.contentView.beginEditing()
        }
    }
    
    func hideContentView() {
        self.contentView.removeFromSuperview()
    }
    
    func show(on view: UIView? = nil) {
        guard let containerView = view ?? UIApplication.shared.keyWindow else {
            return
        }
        containerView.backgroundColor = .white
        containerView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.showContentView()
    }
    
    func dismiss() {
        self.hideContentView()
        self.removeFromSuperview()
    }

}



// MARK: -
class ForexEditAlertContentView: UIView {
    var inputText: String? 
    var sureHandler: ((UIButton) -> Void)?
    var cancelHandler: ((UIButton) -> Void)?
    var errorHandler: ((ForexEditAlertErrorType) -> Void)?
    
    lazy var horizontalGrayLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(221, 221, 221)
        return view
    }()
    
    lazy var verticalGrayLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(221, 221, 221)
        return view
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.rgbColor(0, 0, 0), for: .normal)
        btn.addTarget(self, action: #selector(onClickCancelBtn(sender:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.PingFangSC(size: 18)
        
        return btn
    }()
    
    lazy var sureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确认", for: .normal)
        btn.addTarget(self, action: #selector(onClickSureBtn(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.rgbColor(46, 169, 233), for: .normal)
        btn.titleLabel?.font = UIFont.PingFangSC(size: 18)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(0)
            make.height.equalTo(50)
            make.width.equalTo(135)
        }
        
        addSubview(verticalGrayLine)
        verticalGrayLine.snp.makeConstraints { (make) in
            make.left.equalTo(cancelBtn.snp.right)
            make.width.equalTo(0.5)
            make.bottom.height.equalTo(cancelBtn)
        }
        
        addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(0)
            make.left.equalTo(verticalGrayLine.snp.right)
            make.height.width.equalTo(cancelBtn)
        }
        
        addSubview(horizontalGrayLine)
        horizontalGrayLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(cancelBtn.snp.top)
            make.height.equalTo(0.5)
        }
    }
    
    func beginEditing() {
        
    }
    
    @objc func onClickCancelBtn(sender: UIButton) {
        self.cancelHandler?(sender)
    }
    
    @objc func onClickSureBtn(sender: UIButton) {
        self.errorHandler?(.noneContent)
        self.sureHandler?(sender)
    }
}


class ForexEditAlertConfirmView: ForexEditAlertContentView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "提示"
        label.textColor = UIColor.rgbColor(0, 0, 0)
        label.font = UIFont.PingFangSC(size: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.rgbColor(144, 144, 144)
        label.font = UIFont.PingFangSC(size: 15)
        label.text = "您确定要删除图标上所有的绘画吗？"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfrimSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConfrimSubviews() {
        super.setupSubviews()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(21)
            make.left.right.equalTo(0)
        }
        
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.bottom.equalTo(horizontalGrayLine.snp.top).offset(-15)
        }
    }
}

class ForexEditAlertInputView: ForexEditAlertContentView {
    private let maxInputCount = 20
    
    override var inputText: String? {
        get  {
            return textFiled.text
        }
        set {
            textFiled.text = newValue
            textFiled.resignFirstResponder()
        }
    }
    
    lazy var textFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.font = UIFont.PingFangSC(size: 15)
        let attributePlaceholder = NSAttributedString(string:"请输入文字，最多可输入20字符。" , attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgbColor(187, 187, 187), NSAttributedString.Key.font : UIFont.PingFangSC(size: 15) ?? UIFont.systemFont(ofSize: 15)])
        textFiled.attributedPlaceholder = attributePlaceholder
        textFiled.addTarget(self, action: #selector(onChangeTextFiledChanged(sender:)), for: .editingChanged)
        return textFiled
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInputSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInputSubviews() {
        addSubview(textFiled)
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.top.equalTo(21)
            make.bottom.equalTo(horizontalGrayLine.snp.top).offset(-42)
        }
    }
    
    override func beginEditing() {
        self.textFiled.becomeFirstResponder()
    }
    
    @objc func onChangeTextFiledChanged(sender: UITextField) {
        guard sender == textFiled, let text = sender.text else {
            return
        }
        
        if text.count > maxInputCount {
            let endIndex = text.index(text.startIndex, offsetBy: maxInputCount)
            let subText = text[text.startIndex..<endIndex]
            sender.text = String(subText)
            self.errorHandler?(.upWordLimit)
        }
    }
}
