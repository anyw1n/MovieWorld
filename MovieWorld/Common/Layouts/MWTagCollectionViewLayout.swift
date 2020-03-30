//
//  MWTagCollectionViewLayout.swift
//  MovieWorld
//
//  Created by Alexey Zhizhensky on 3/29/20.
//  Copyright © 2020 Alexey Zhizhensky. All rights reserved.
//

import UIKit

class MWTagCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: MWTagCollectionViewLayoutDelegate?
    
    private let numberOfRows = 2
    private let ySpacing: CGFloat = 8
    private let xSpacing: CGFloat = 10
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat {
        guard let collectionView = self.collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    
    private var contentWidth: CGFloat = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let rowHeight = (self.contentHeight - self.ySpacing) / CGFloat(self.numberOfRows)
        var yOffset: [CGFloat] = []
        for row in 0..<self.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight + (row != 0 ? self.ySpacing : 0))
        }
        var row = 0
        var xOffset: [CGFloat] = .init(repeating: 0, count: self.numberOfRows)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let tagWidth = self.delegate?.collectionView(collectionView,
                                                         widthForTagAtIndexPath: indexPath) ?? 100
            let frame = CGRect(x: xOffset[row],
                               y: yOffset[row],
                               width: tagWidth,
                               height: rowHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            self.cache.append(attributes)
            
            self.contentWidth = max(self.contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + tagWidth + (item != collectionView.numberOfItems(inSection: 0) - 1 ? self.xSpacing : 0)
            
            row = row < (self.numberOfRows - 1) ? (row + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }
}

protocol MWTagCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        widthForTagAtIndexPath indexPath: IndexPath) -> CGFloat
}
