//
//  EnterHobbyView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/10.
//

import UIKit
import SnapKit
import Then

final class EnterHobbyView: UIView, ViewRepresentable {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    
    let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 12
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 18)
        $0.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 16)
    }
    
    
    func collectionViewConfig() {
        collectionView.register(EnterHobbyCollectionViewCell.self,
                                forCellWithReuseIdentifier: EnterHobbyCollectionViewCell.reuseIdentifier)
        collectionView.register(EnterHobbyCollectionViewSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: EnterHobbyCollectionViewSectionHeader.reuseIdentifier)
    }
    
    func setUp() {
        self.backgroundColor = .systemBackground
        self.addSubview(collectionView)
        collectionViewConfig()
        
    }
    
    func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
