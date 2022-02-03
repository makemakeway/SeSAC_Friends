//
//  InfoStackView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit
import Then

class InfoStackView: UIStackView, ViewRepresentable {
    let genderView = InfoGenderView()
    let hobbyView = InfoHobbyView()
    let allowView = InfoAllowPhoneNumberSearchView()
    let ageRestrictView = InfoAgeRestrictView()
    let withdrawView = InfoWithdrawView()
    
    func setUp() {
        self.axis = .vertical
        self.alignment = .center
        self.spacing = 24
        
        [genderView, hobbyView, allowView, ageRestrictView, withdrawView].forEach {
            addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        genderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        hobbyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        allowView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        ageRestrictView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        withdrawView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
