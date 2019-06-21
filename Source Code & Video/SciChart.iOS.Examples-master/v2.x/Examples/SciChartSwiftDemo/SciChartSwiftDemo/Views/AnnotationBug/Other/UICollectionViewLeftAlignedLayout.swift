//
//  UICollectionViewLeftAlignedLayout.swift
//  Module_MsgCenter
//
//  Created by bailun on 2019/3/27.
//  Copyright © 2019 bailun. All rights reserved.
//

import UIKit

fileprivate extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(withSectionInset sectionInset: UIEdgeInsets) {
        var frame: CGRect = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}

class UICollectionViewLeftAlignedLayout : UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var updatedAttributes = [UICollectionViewLayoutAttributes]()
        originalAttributes.forEach { (attribute) in
            updatedAttributes.append(attribute.copy() as! UICollectionViewLayoutAttributes)
        }
        for (index, attributes) in originalAttributes.enumerated() {
            if attributes.representedElementKind == nil {
                if let layout = layoutAttributesForItem(at: attributes.indexPath) {
                    updatedAttributes[index] = layout
                }
            }
        }
        return updatedAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView, let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        let sectionInset: UIEdgeInsets = evaluatedSectionInsetForItem(at: indexPath.section)
        let isFirstItemInSection: Bool = indexPath.item == 0
        let layoutWidth: CGFloat = collectionView.frame.width - sectionInset.left - sectionInset.right
        
        if isFirstItemInSection {
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let previousFrame: CGRect = layoutAttributesForItem(at: previousIndexPath)?.frame ?? .zero
        let previousFrameRightPoint: CGFloat = previousFrame.origin.x + previousFrame.size.width
        let currentFrame: CGRect = currentItemAttributes.frame
        let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame.origin.y, width: layoutWidth, height: currentFrame.size.height)
        
        let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
        if isFirstItemInRow {
            currentItemAttributes.leftAlignFrame(withSectionInset: sectionInset)
            return currentItemAttributes
        }
        
        var frame: CGRect = currentItemAttributes.frame
        frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
        currentItemAttributes.frame = frame
        return currentItemAttributes
    }

}


// MARK: - Assistant
extension UICollectionViewLeftAlignedLayout {
    private func evaluatedMinimumInteritemSpacingForSection(at sectionIndex: Int) -> CGFloat {
        let sel = #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))
        guard let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout, delegate.responds(to: sel) else {
            return minimumInteritemSpacing
        }
        return delegate.collectionView!(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
    }
    
    private func evaluatedSectionInsetForItem(at index: Int) -> UIEdgeInsets {
        let sel = #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))
        guard let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout, delegate.responds(to: sel) else {
            return sectionInset
        }
        return delegate.collectionView!(self.collectionView!, layout: self, insetForSectionAt: index)
        
    }
}
