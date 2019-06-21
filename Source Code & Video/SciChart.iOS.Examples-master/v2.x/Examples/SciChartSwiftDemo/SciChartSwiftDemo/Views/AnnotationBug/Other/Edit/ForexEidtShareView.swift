//
//  ForexEditShareView.swift
//  QuickRun
//
//  Created by bailun on 2019/6/10.
//  Copyright © 2019 bailun. All rights reserved.
//

import UIKit
import SnapKit

enum ForexEditSharePlatformType: CaseIterable {
    case wechat
    case moments
    case sina
    case qq
    case qqZone
    
    func title() -> String {
        var title: String = ""
        switch self {
        case .wechat:
            title = "微信好友"
        case .moments:
            title = "朋友圈"
        case .sina:
            title = "新浪微博"
        case .qq:
            title = "QQ好友"
        case .qqZone:
            title = "QQ空间"
        }
        return title
    }
    
    func image() -> UIImage? {
        var image: UIImage?
        switch self {
        case .wechat:
            image = R.image.forex_share_wechat()
        case .moments:
            image = R.image.forex_share_moments()
        case .sina:
            image = R.image.forex_share_sina()
        case .qq:
            image = R.image.forex_share_qq()
        case .qqZone:
            image = R.image.forex_share_zone()
        }
        return image
    }
}

class ForexEditShareView: UIView {
    
    var shareToFxChatHandler: ((String?, UIImage) -> Void)?
    var shareToThirdPlatfromHandler: ((ForexEditSharePlatformType, UIImage) -> Void)?
    var shareImage: UIImage? = nil {
        didSet {
            let maxSize = self.imageViewMaxSize()
            let imageViewDisaplySize = self.resize(realSize: shareImage?.size ?? .zero , maxSize: maxSize)
            self.imageView.snp.updateConstraints { (make) in
                make.size.equalTo(imageViewDisaplySize)
            }
            self.imageView.image = self.shareImage
        }
    }
    
    private var platfromList = [ForexEditSharePlatformType]()
    private let reuseId = "ForexEditShareViewItemCell"
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(245, 245, 249)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.forex_share_close(), for: .normal)
        btn.addTarget(self, action: #selector(onClickCloseBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var inputTextFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.font = UIFont.PingFangSC(size: 14)
        textFiled.textColor = UIColor.rgbColor(48, 48, 48)
        let placeholder = NSAttributedString(string: "输入分享理由，或说点什么", attributes: [NSAttributedString.Key.font : UIFont.PingFangSC(size: 14) ?? UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgbColor(192, 192, 192)])
        textFiled.attributedPlaceholder = placeholder
        textFiled.backgroundColor = .white
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        textFiled.leftView = leftView
        textFiled.leftViewMode = .always
        textFiled.layer.cornerRadius = 4.0
        textFiled.layer.borderColor = UIColor.rgbColor(221, 221, 221).cgColor
        textFiled.layer.masksToBounds = true
        return textFiled
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.rgbColor(36, 169, 223)
        btn.setTitle("分享给汇友", for: .normal)
        btn.setTitleColor(UIColor.rgbColor(255, 255, 255), for: .normal)
        btn.titleLabel?.font = UIFont.PingFangSC(size: 13)
        btn.addTarget(self, action: #selector(onClickShareBtn(sender:)), for: .touchUpInside)
        btn.layer.cornerRadius = 3.0
        return btn
    }()
    
    lazy var leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(221, 221, 221)
        return view
    }()
    
    lazy var shareTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.PingFangSC(size: 13)
        label.textColor = UIColor.rgbColor(192, 192, 192)
        label.text = "还可以分享到"
        label.textAlignment = .center
        return label
    }()
    
    lazy var rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(221, 221, 221)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let itemSize = CGSize(width: 60, height: 104)
        flowLayout.itemSize = itemSize
        flowLayout.scrollDirection = .horizontal
        if self.platfromList.count > 0 {
            var minimumLineSpacing = (UIScreen.main.bounds.size.width - 64 * 2 - CGFloat(self.platfromList.count) * itemSize.width) / CGFloat(self.platfromList.count - 1)
            minimumLineSpacing = CGFloat(floor(Double(minimumLineSpacing)))
            flowLayout.minimumLineSpacing = minimumLineSpacing
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ForexEditShareViewItemCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.rgbColor(245, 245, 249)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.platfromList = ForexEditSharePlatformType.allCases
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        let rect = contentView.bounds
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        contentView.layer.mask = maskLayer
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor.rgbToColor(r: 0, g: 0, b: 0, a: 0.5)
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(23)
        }
        
        let size = self.imageViewMaxSize()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.size.equalTo(size)
        }
        
        contentView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.top.equalTo(0)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        contentView.addSubview(inputTextFiled)
        inputTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.height.equalTo(36)
        }
        
        contentView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(36)
            make.width.equalTo(99)
            make.left.equalTo(inputTextFiled.snp.right).offset(15)
            make.centerY.equalTo(inputTextFiled)
        }
        
        contentView.addSubview(shareTitleLabel)
        shareTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputTextFiled.snp.bottom).offset(31)
            make.width.equalTo(98)
        }
        
        contentView.addSubview(leftLineView)
        leftLineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(0.5)
            make.right.equalTo(shareTitleLabel.snp.left)
            make.centerY.equalTo(shareTitleLabel)
        }
        
        contentView.addSubview(rightLineView)
        rightLineView.snp.makeConstraints { (make) in
            make.left.equalTo(shareTitleLabel.snp.right)
            make.right.equalTo(0)
            make.centerY.equalTo(shareTitleLabel)
            make.height.equalTo(0.5)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(shareTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(64)
            make.right.equalTo(-64)
            make.height.equalTo(104)
        }
        
    }
    
    @objc func onClickShareBtn(sender: UIButton) {
        guard let shareImage = self.shareImage else {
            return
        }
        self.shareToFxChatHandler?(self.inputTextFiled.text, shareImage)
        self.dismiss()
    }
    
    @objc func onClickCloseBtn(sender: UIButton) {
        self.dismiss()
    }
    
    private func showContentView() {
        contentView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.snp.bottom)
        }
        self.layoutIfNeeded()
        
        contentView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(23)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    private func hideContentView() {
        contentView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-UIScreen.main.bounds.height)
            make.top.equalTo(UIScreen.main.bounds.height)
        }
        
        UIView.animate(withDuration: 2.5) {
            self.layoutIfNeeded()
        }
    }
    
    func show(on view: UIView? = nil) {
        guard let mySuperView = view ?? UIApplication.shared.keyWindow else {
            return
        }
        
        mySuperView.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        self.showContentView()
    }
    
    func dismiss()  {
        self.removeFromSuperview()
    }
    
    /// 重新计算图片的尺寸
    ///
    /// - Parameters:
    ///   - realSize: 图片实际尺寸
    ///   - maxSize: 图片显示的最大尺寸
    ///   - contentMode: 图片填充模式， default = .scaleAspectFit
    ///   - enableScaleUp: scale up, default = true
    ///   - enableScaleDown: scale down, default = true
    /// - Returns: 图片显示尺寸
    func resize(realSize: CGSize, maxSize: CGSize, contentMode: UIView.ContentMode = .scaleAspectFit, enableScaleUp: Bool = true, enableScaleDown: Bool = true) -> CGSize {
        var size = maxSize
        if 0 == realSize.width || 0 == realSize.height {
            return size
        }
        let maxWidth = maxSize.width
        let maxHeight = maxSize.height
        let realImageViewWidth: CGFloat = realSize.width
        let realImageViewHeight: CGFloat = realSize.height
        
        switch contentMode {
        case .scaleAspectFit:
            let scaleX = maxWidth / realImageViewWidth
            let scaleY = maxHeight / realImageViewHeight
            var scale = min(scaleX, scaleY)
            if (scale > 1.0 && !enableScaleUp) || (scale < 1.0 && !enableScaleDown) {
                scale = 1.0
            }
            size = CGSize(width: realImageViewWidth * scale + 20, height: realImageViewHeight * scale)
            
        case .scaleAspectFill:
            let scaleX = maxWidth / realImageViewWidth
            let scaleY = 164 / realImageViewHeight
            var scale = max(scaleX, scaleY)
            if (scale > 1.0 && !enableScaleUp) || (scale < 1.0 && !enableScaleDown) {
                scale = 1.0
            }
            size = CGSize(width: realImageViewWidth * scale, height: realImageViewHeight * scale)
            
        case .scaleToFill:
            var scaleX = maxWidth / realImageViewWidth
            var scaleY = maxHeight / realImageViewHeight
            if scaleX > 1.0 && !enableScaleUp || scaleX < 1.0 && !enableScaleDown {
                scaleX = 1.0
            }
            
            if scaleX > 1.0 && !enableScaleUp || scaleY < 1.0 && enableScaleDown {
                scaleY = 1.0
            }
            size = CGSize(width: realImageViewWidth * scaleX, height: realImageViewHeight * scaleY)
        default:
            size = maxSize
        }
        return size
    }
    
    func imageViewMaxSize() -> CGSize {
       
        let imageSize = CGSize(width: 217 , height: 122)
        let imageWidth = imageSize.width * (UIScreen.main.bounds.size.width / 667.0)
        let imageHeight = imageSize.height * ((UIScreen.main.bounds.size.height) / 375)
        return CGSize(width:imageWidth, height: imageHeight)
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ForexEditShareView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platfromList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! ForexEditShareViewItemCell
        let platform = self.platfromList[indexPath.row]
        cell.platform = platform
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let shareImage = self.shareImage else {
            return
        }
        self.shareToThirdPlatfromHandler?(self.platfromList[indexPath.row], shareImage)
        self.dismiss()
    }
}


class ForexEditShareViewItemCell: UICollectionViewCell {
    
    var platform: ForexEditSharePlatformType = .wechat {
        didSet {
            self.platformImageView.image = self.platform.image()
            self.platformNameLabel.text = self.platform.title()
        }
    }
    
    lazy var platformImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var platformNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgbColor(144, 144, 144)
        label.font = UIFont.PingFangSC(size: 10)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        contentView.addSubview(platformImageView)
        platformImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(60)
        }
        
        contentView.addSubview(platformNameLabel)
        platformNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(platformImageView.snp.bottom).offset(10)
        }
    }
}
