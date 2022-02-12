//
//  EnterHobbyCollectionViewLayout.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/11.
//

import UIKit

final class EnterHobbyCollectionViewLayout: UICollectionViewFlowLayout {
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
//            return nil
//        }
//        
//        var startX: CGFloat = 0.0
//        var startY: CGFloat = 0.0
//        let contentWidth = collectionView?.frame.width ?? 0
//        
//        for layoutAttributes in layoutAttributes {
//            let size = layoutAttributes.size
//            if (startX + size.width + minimumInteritemSpacing) > contentWidth {
//                startX = 0
//                startY += size.height
//                startY += minimumLineSpacing
//            }
//            let origin = CGPoint(x: startX, y: startY)
//            let frame = CGRect(origin: origin, size: size)
//            layoutAttributes.frame = frame
//            startX += size.width + minimumInteritemSpacing
//        }
//        return layoutAttributes
//    }
}
