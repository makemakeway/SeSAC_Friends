//
//  OnBoardingCollectionViewCell.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/01.
//

import UIKit
import SnapKit

class OnBoardingCollectionViewCell: UICollectionViewCell, ViewRepresentable {
    
    static let identifier = "OnBoardingCollectionViewCell"
    
    let labelContainer = UIView()
    let labelImageView = UIImageView()
    let centerImageView = UIImageView()
    
    func setUp() {
        contentView.addSubview(labelContainer)
        contentView.addSubview(centerImageView)
        labelContainer.addSubview(labelImageView)
    }
    
    func setConstraints() {
        centerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(UIScreen.main.bounds.height * 0.305)
            make.height.equalTo(centerImageView.snp.width)
        }
        
        labelContainer.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(72)
            make.centerX.equalToSuperview()
            make.height.equalTo(72)
        }
        
        labelImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
