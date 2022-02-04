//
//  AllowPhoneNumberSearchView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import Then
import SnapKit

class InfoAllowPhoneNumberSearchView: UIView, ViewRepresentable {
    
    let allowPhoneNumberLabel = UILabel().then {
        $0.font = .title4_R14
        $0.textColor = .defaultBlack
        $0.text = "내 번호 검색 허용"
    }
    
    let allowSwitch = UISwitch().then {
        $0.onTintColor = .brandGreen
    }
    
    func setUp() {
        addSubview(allowPhoneNumberLabel)
        addSubview(allowSwitch)
    }
    
    func setConstraints() {
        allowPhoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        allowSwitch.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(52.0/343.0)
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
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
