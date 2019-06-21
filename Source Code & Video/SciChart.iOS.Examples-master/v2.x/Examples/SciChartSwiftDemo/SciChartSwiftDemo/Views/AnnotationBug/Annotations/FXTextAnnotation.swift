//
//  FXTextAnnotation.swift
//  FXChat
//
//  Created by bailun on 2019/6/13.
//  Copyright © 2019 PengZhihao. All rights reserved.
//

import UIKit
import SciChart

class ForexTextAnnotationBackgroundView: UIView {
    
    private let triangleSize: CGSize = CGSize(width: 5, height: 5)
    var strokeColor: UIColor = UIColor(red: 214, green: 32, blue: 32)
    var fillColor: UIColor = .clear
    
    override func draw(_ rect: CGRect) {
        let startPoint = CGPoint(x: rect.size.width * 0.5, y: 0) // 三角形顶点
        let leftPoint = CGPoint(x: rect.size.width * 0.5 - triangleSize.width * 0.5, y: triangleSize.height)
        let rightPoint = CGPoint(x: rect.size.width * 0.5 + triangleSize.width * 0.5, y: triangleSize.height)
        let lineWidth: CGFloat = 0.5
        
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.setLineWidth(lineWidth)
        context?.move(to: startPoint)
        context?.addLine(to: leftPoint)
        context?.addLine(to: CGPoint(x: lineWidth, y: triangleSize.height))
        context?.addLine(to: CGPoint(x: lineWidth, y: rect.size.height - lineWidth))
        context?.addLine(to: CGPoint(x: rect.width - lineWidth, y: rect.height - lineWidth))
        context?.addLine(to: CGPoint(x: rect.width - lineWidth, y: triangleSize.height))
        context?.addLine(to: rightPoint)
        context?.addLine(to: startPoint)
        
        context?.setFillColor(fillColor.cgColor)
        context?.setStrokeColor(strokeColor.cgColor)
        context?.drawPath(using: .fillStroke)
    }
}

class FXTextAnnotationTextView: UITextView {
    var colorStyle: ForexColorStyle = .red {
        didSet {
            updateColorStyle()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            updateColorStyle()
        }
    }
    
    var doubelTapHandler: (() -> Void)?
    
    lazy var backgroundView: ForexTextAnnotationBackgroundView = {
        let view = ForexTextAnnotationBackgroundView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var doubleTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(sender:)))
        tap.numberOfTapsRequired = 2
        return tap
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.textContainerInset = UIEdgeInsets(top: 9, left: 0, bottom: 0, right: 0)
        self.addSubview(backgroundView)
        self.sendSubview(toBack: backgroundView)
        self.isUserInteractionEnabled = true
        self.setupDoubleTapGesture(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = heightFormText()
        return CGSize(width: size.width + 16, height: 26)
    }
    
    private func heightFormText() -> CGSize {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = self.text
        let maxWidth = UIScreen.main.bounds.width
        return label.sizeThatFits(CGSize(width: maxWidth, height: 1000))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.frame = self.bounds
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        self.backgroundView.setNeedsDisplay()
        self.sendSubview(toBack: backgroundView)
    }
    
    private func updateColorStyle() {
        self.backgroundView.strokeColor = self.colorStyle.color()
        if isSelected {
            self.backgroundView.fillColor = colorStyle.color(alpha: 0.2)
        } else {
            self.backgroundView.fillColor = .clear
        }
        self.backgroundView.setNeedsDisplay()
    }
    
    func setupDoubleTapGesture(for view: UIView) {
        view.removeGestureRecognizer(doubleTapGesture)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func handleDoubleTapGesture(sender: UITapGestureRecognizer) {
        self.doubelTapHandler?()
    }
}


class FXTextAnnotation: SCITextAnnotation {
    var selectHandler: ((SCIAnnotationBase, Bool) -> Void)?  // 选中
    var updateHandler: ((SCIAnnotationBase) -> Void)?        // 选中之后再点击就会变为更新
    override var text: String! {
        didSet {
            self.textView.setNeedsLayout()
            self.textView.layoutIfNeeded()
            self.textView.setNeedsDisplay()
        }
    }
    
    
    var colorStyle: ForexColorStyle = .red {
        didSet {
            self.style.textColor = colorStyle.color()
            if let view = self.textView as? FXTextAnnotationTextView {
                view.colorStyle = colorStyle
            }
        }
    }
    
    override var isSelected: Bool {
        willSet {
            guard newValue, nil != self.parentSurface else {
                return
            }
            
            let annotations = self.parentSurface.annotations
            let count = UInt32(annotations.count())
            for index in 0..<count {
                let annotation = annotations[index]
                let isFXAnnotation = FXAnnotationManager.shared.isFXAnnotation(annotation!)
                if !(annotation!.annotationName == self.annotationName)  && isFXAnnotation {
                    annotation!.isSelected = false
                }
            }
        }
        
        didSet {
            if let view = self.textView as? FXTextAnnotationTextView {
                view.isSelected = self.isSelected
            }
            self.selectHandler?(self, isSelected)
        }
        
    }
    
    override init() {
        super.init()
        let view = FXTextAnnotationTextView()
        view.doubelTapHandler = { [weak self] in
            guard let self = self, self.isSelected else {
                return
            }
            self.updateHandler?(self)
        }
        self.textView = view
    }
}
