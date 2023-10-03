//
//  RowLayout.swift
//  VK
//
//  Created by Сергей Насыбуллин on 30.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

protocol RowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPatch indexPacth: IndexPath) -> CGSize
}

class RowLayout: UICollectionViewLayout {
    
    weak var delegate: RowLayoutDelegate!
    
    static var numberOfRows = 2
    
    fileprivate var cellPadding: CGFloat = 12
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentWidth: CGFloat = 0
    
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let inserts = collectionView.contentInset
        return collectionView.bounds.height - (inserts.left + inserts.right)
    }
    
    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        contentWidth = 0
        cache = []
        
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        var photos = [CGSize]()
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPatch = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView, photoAtIndexPatch: indexPatch)
            photos.append(photoSize)
        }
        
        guard var rowHeight = RowLayout.rowHeightConter(collectionViewWidth: collectionView.frame.width, photosArray: photos) else { return }
        
        rowHeight = rowHeight / CGFloat( RowLayout.numberOfRows )
        
        let photosRatios = photos.map{ $0.height / $0.width }
        
        
        var yOffset = [CGFloat]()
        for row in 0..<RowLayout.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }
        
        var row = 0
        var xOffset = [CGFloat](repeating: 0, count: RowLayout.numberOfRows)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPatch = IndexPath(item: item, section: 0)
            
            let ration = photosRatios[indexPatch.row]
            let width = rowHeight / ration
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPatch)
            attribute.frame = insetFrame
            cache.append(attribute)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            row = row < (RowLayout.numberOfRows - 1) ? (row + 1) : 0
        }
        
    }
    
    
    /// Находит самую "высокую фотографию"
    static func rowHeightConter(collectionViewWidth: CGFloat, photosArray: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat
        let photoWitchMinRation = photosArray.min { firstSize, secondSize in
            (firstSize.height / firstSize.width) < (secondSize.height / secondSize.width)
        }
        guard let photoWitchMinRation = photoWitchMinRation else { return nil }
        let difference = collectionViewWidth / photoWitchMinRation.width
        rowHeight = photoWitchMinRation.height * difference
        
        return rowHeight * CGFloat(RowLayout.numberOfRows)
    }
    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }
    
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[indexPath.row]
    }
    
    
    
}
