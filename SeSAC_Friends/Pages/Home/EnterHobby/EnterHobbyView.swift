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
    
    let collectionViewLayout = UICollectionViewLayout.fixedSpacedFlowLayout()
    
    let searchSesacButton = H48Button().then {
        $0.buttonState = .fill
        $0.setTitle("새싹 찾기", for: .normal)
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
        self.addSubview(searchSesacButton)
        collectionViewConfig()
        
    }
    
    func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchSesacButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
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
