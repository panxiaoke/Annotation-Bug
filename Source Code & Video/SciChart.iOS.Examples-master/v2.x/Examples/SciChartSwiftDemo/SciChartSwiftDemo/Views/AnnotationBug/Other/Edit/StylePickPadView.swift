//
//  StylePickPadView.swift
//  Test
//
//  Created by bailun on 2019/6/5.
//  Copyright © 2019 bailun. All rights reserved.
//

import UIKit

class StylePickModel {
    var image: UIImage?
    var title: String?
    var style: Int = 0
}

enum ForexColorStyle: UInt, CaseIterable {
    case red = 0xffd62020      // 对应色值的colorCode
    case green = 0xff33d6a8
    case purple = 0xff775dd2
    
    func image() -> UIImage? {
        var image: UIImage?
        switch self {
        case .red:
            image = R.image.color_picker_red()
        case .green:
            image = R.image.color_picker_green()
        case .purple:
            image = R.image.color_picker_purple()
        }
        return image
    }
    
    func title() -> String {
        var title: String!
        switch self {
        case .red:
            title = "红色"
        case .green:
            title = "绿色"
        case .purple:
            title = "紫色"
        }
        return title
    }
    
    func color(alpha: CGFloat = 1.0) -> UIColor {
        var color: UIColor!
        switch self {
        case .red:
            color = UIColor(red: 214, green: 32, blue: 32, alpha: alpha)
        case .green:
            color = UIColor(red: 51, green: 214, blue: 168, alpha: alpha)
        case .purple:
            color = UIColor(red: 119, green: 93, blue: 210, alpha: alpha)
        }
        return color
    }
}

enum ForexLineStyle: Int, CaseIterable {
    case horizotal
    case vertical
    case slash
    
    func image() -> UIImage? {
        var image: UIImage?
        switch self {
        case .horizotal:
            image = R.image.line_picker_horizontal()
        case .vertical:
            image = R.image.line_picker_vertical()
        case .slash:
            image = R.image.line_picker_slash()
        }
        return image
    }
    
    func title() -> String {
        var title: String!
        switch self {
        case .horizotal:
            title = "水平线"
        case .vertical:
            title = "垂直线"
        case .slash:
            title = "斜线"
        }
        return title
    }
    
}

class StylePickPadView: UIView {
    var itemSize: CGSize = .zero
    var clickHandler: ((StylePickModel) -> Void)?
    
    lazy var colletionView: UICollectionView = {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(StylePickPadItemCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        let view = UIView()
        view.backgroundColor = .clear
        collectionView.backgroundView = view
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
     var styleList: [StylePickModel] = [] {
        didSet {
            self.colletionView.reloadData()
        }
    }

    private var reuseId: String = "StylePickPadItemCell"

    
    init(itemSize: CGSize) {
        super.init(frame: .zero)
        self.itemSize = itemSize
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.9)
        addSubview(colletionView)
        colletionView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension StylePickPadView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! StylePickPadItemCell
        let style = self.styleList[indexPath.row]
        cell.setStyleItem(style)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selStyle = self.styleList[indexPath.row]
        self.clickHandler?(selStyle)
    }
}


class StylePickPadItemCell: UICollectionViewCell {
    
    lazy var styleImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var styleNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 96, green: 96, blue: 96, alpha: 1)
        label.font = UIFont.PingFangSC(size: 11)
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
        contentView.addSubview(styleImageView)
        styleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(4)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(styleNameLabel)
        styleNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(styleImageView)
            make.top.equalTo(styleImageView.snp.bottom).offset(4)
        }
    }
    
    func setStyleItem(_ style: StylePickModel) {
        self.styleImageView.image = style.image
        self.styleNameLabel.text = style.title
    }
}
