//
//  EditToolBar.swift
//  FXChat
//
//  Created by bailun on 2019/6/4.
//  Copyright © 2019 PengZhihao. All rights reserved.
//

import UIKit

enum EditToolBarItemTypeEnum {
    static let allCases: [EditToolBarItemTypeEnum] = [.close, .delete(isEnabled: false), .undo(isEnabled: false), .line, .text, .colorPicker(style: .red), .share]
    
    case close  // 收起
    case delete(isEnabled: Bool) // 删除
    case undo(isEnabled: Bool)   // 撤销
    case line   // 绘图
    case text   // 文字
    case colorPicker(style: ForexColorStyle) // 选色
    case share  // 分享
    
    func image() -> UIImage? {
        var image: UIImage?
        switch self {
        case .close:
            image = R.image.edit_toolbar_colse()
        case .delete(let isEnabled):
            image = isEnabled ? R.image.edit_toolbar_delete() : R.image.toolbar_delete_disabled()
        case .undo(let isEnabled):
            image = isEnabled ? R.image.edit_toolbar_undo() : R.image.toolbar_undo_disabled()
        case .line:
            image = R.image.edit_toolbar_draw()
        case .text:
            image = R.image.edit_toolbar_text()
        case .colorPicker(let style):
            image = style.image()
        case .share:
            image = R.image.edit_toolbar_share()
        }
        return image
    }
    
    func title() -> String {
        var title: String = ""
        switch self {
        case .close:
            title = "close"
        case .delete:
            title = "remove"
        case .undo:
            title = "undo"
        case .line:
            title = "line"
        case .text:
            title = "text"
        case .colorPicker:
            title = "color pick"
        case .share:
            title = "share"
        }
        return title
    }
    
    func isEnabled() -> Bool {
        var enabled = true
        switch self {
        case .delete(let isEnabled):
            enabled = isEnabled
        case .undo(let isEnabled):
            enabled = isEnabled
        default:
            break
        }
        
        return enabled
    }
}

class ForexEditToolBar: UIView {
    private let reuseId = "ForexEditToolBarItemCell"
    private var functionList = [EditToolBarItemTypeEnum]()
    private var toolBarWidth: CGFloat = UIScreen.main.bounds.size.height
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = CGFloat(floor(Double(toolBarWidth / CGFloat(functionList.count))))
        let itemSize = CGSize(width: itemWidth, height: 53)
        flowLayout.itemSize = itemSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ForexEditToolBarItemCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.dataSource = self
        collectionView.delegate = self
        let view = UIView()
        view.backgroundColor = UIColor(red: 48, green: 48, blue: 48)
        collectionView.backgroundView = view
        return collectionView
    }()
    
    var clickHandler: ((EditToolBarItemTypeEnum) -> Void)?
    
    init(width: CGFloat) {
        super.init(frame: .zero)
        self.toolBarWidth = width
        EditToolBarItemTypeEnum.allCases.forEach { (item) in
            functionList.append(item)
        }
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.backgroundColor = .white
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(53)
        }
    }
    
    func changeColorStyle(newStyle: ForexColorStyle) {
        self.functionList = self.functionList.map({ (item) -> EditToolBarItemTypeEnum in
            switch item {
            case .colorPicker(_):
                return .colorPicker(style: newStyle)
            default:
                return item
            }
            
        })
        self.collectionView.reloadData()
    }
    
    func changeDeleteEnabled(isEnabled: Bool) {
        self.functionList = self.functionList.map({ (item) -> EditToolBarItemTypeEnum in
            switch item {
            case .delete(_):
                return .delete(isEnabled: isEnabled)
            default:
                return item
            }
            
        })
        self.collectionView.reloadData()
    }
    
    func changeUndoEnabled(isEnabled: Bool) {
        self.functionList = self.functionList.map({ (item) -> EditToolBarItemTypeEnum in
            switch item {
            case .undo(_):
                return .undo(isEnabled: isEnabled)
            default:
                return item
            }
            
        })
        self.collectionView.reloadData()
    }
    
}

extension ForexEditToolBar: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! ForexEditToolBarItemCell
        let function = self.functionList[indexPath.row]
        cell.function = function
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let function = self.functionList[indexPath.row]
        if function.isEnabled() {
            self.clickHandler?(function)
        }
    }
    
}


/// MARK: - ForexEditToolBarItemCell
class ForexEditToolBarItemCell: UICollectionViewCell {
    var function: EditToolBarItemTypeEnum = .close {
        didSet {
            let textColor = function.isEnabled() ? UIColor(red: 255, green: 255, blue: 255, alpha: 1) : UIColor(red: 255, green: 255, blue: 255, alpha: 0.25)
            self.functionTextLabel.textColor = textColor
            self.functionTextLabel.text = function.title()
            self.functionImageView.image = function.image()
        }
    }
    
    lazy var functionImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var functionTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularFont(of: 11)
        label.textColor = .white
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
        contentView.addSubview(functionImageView)
        functionImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(8)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(functionTextLabel)
        functionTextLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(functionImageView.snp.bottom).offset(4)
        }
    }
}


