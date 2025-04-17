//
//  CardStackLayout.swift
//  SwipeCards
//
//  Created by MacBook Pro on 17/04/2025.
//

import UIKit

class CardStackLayout: UICollectionViewLayout {
    private let itemSize = CGSize(width: 350, height: 620)
    private let visibleCount = 3
    private let spacing: CGFloat = 10
    private var itemAttributes: [UICollectionViewLayoutAttributes] = []

    override var collectionViewContentSize: CGSize {
        return collectionView?.bounds.size ?? .zero
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }

        itemAttributes = []

        let itemCount = min(collectionView.numberOfItems(inSection: 0), visibleCount)

        for index in 0..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            let scale: CGFloat = index == 0 ? 1.0 : 1.0 - (CGFloat(index) * 0.10)
            let yOffset = CGFloat(index) * spacing

            let frame = CGRect(
                x: (collectionView.bounds.width - itemSize.width) / 2,
                y: (collectionView.bounds.height - itemSize.height) / 2 + yOffset,
                width: itemSize.width,
                height: itemSize.height
            )

            attributes.frame = frame
            attributes.transform = index == 0 ? .identity : CGAffineTransform(scaleX: scale, y: scale)
            attributes.zIndex = visibleCount - index
            itemAttributes.append(attributes)
        }
    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes.first(where: { $0.indexPath == indexPath })
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

