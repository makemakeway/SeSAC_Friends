//
//  CardNicknameView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/15.
//

import UIKit
import Then
import SnapKit

final class CardNicknameView: UIView, ViewRepresentable {
    
    let nicknameLabel = UILabel().then {
        $0.font = .title1_M16
        $0.textColor = .defaultBlack
        $0.text = UserInfo.nickname
    }
    let chevronImageView = UIImageView(image: UIImage(asset: Asset.moreArrow)).then {
        $0.transform = CGAffineTransform(rotationAngle: -.pi / 2)
    }
    
    func setUp() {
        addSubview(nicknameLabel)
        addSubview(chevronImageView)
    }
    
    func setConstraints() {
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-18)
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
