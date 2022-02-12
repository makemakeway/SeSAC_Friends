//
//  UICollectionViewLayout+Extension.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/11.
//

import UIKit

extension UICollectionViewLayout {
    static func fixedSpacedFlowLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .estimated(32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                      heightDimension: .absolute(18)),
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16)
        section.interGroupSpacing = 12
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
