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
        
        let sectionHeaderPadding: CGFloat = 32
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16 + sectionHeaderPadding,
                                                        leading: 16,
                                                        bottom: 8,
                                                        trailing: 16)
        section.interGroupSpacing = 12
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                    heightDimension: .absolute(18)),
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .topLeading,
                                                                 absoluteOffset: CGPoint(x: 0, y: sectionHeaderPadding))
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    static func searchSesacLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .estimated(32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 12
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
