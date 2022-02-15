//
//  SesacHobbyView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/15.
//

import UIKit
import Then
import SnapKit

final class SesacHobbyView: UIView, ViewRepresentable {
    
    let sesacHobbyLabel = UILabel().then {
        $0.font = .title6_R12
        $0.textColor = .defaultBlack
        $0.text = "하고 싶은 취미"
    }
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    let collectionViewLayout = UICollectionViewLayout.searchSesacLayout()
    
    func setUp() {
        addSubview(sesacHobbyLabel)
        addSubview(collectionView)
        collectionView.register(EnterHobbyCollectionViewCell.self,
                                forCellWithReuseIdentifier: EnterHobbyCollectionViewCell.useIdentifier)
        
        
    }
    
    func setConstraints() {
        sesacHobbyLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top).offset(-16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sesacHobbyLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(32)
            make.bottom.equalToSuperview()
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
