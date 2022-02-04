//
//  InfoGenderView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit
import Then

class InfoGenderView: UIView, ViewRepresentable {
    
    let genderLabel = UILabel().then {
        $0.font = .title4_R14
        $0.textColor = .defaultBlack
        $0.text = "내 성별"
    }
    
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    let manButton = H48Button().then {
        $0.setTitle("남자", for: .normal)
        $0.buttonState = .inactive
    }
    
    let womanButton = H48Button().then {
        $0.setTitle("여자", for: .normal)
        $0.buttonState = .inactive
    }
    
    func setUp() {
        [manButton, womanButton].forEach {
            buttonStack.addArrangedSubview($0)
        }
        
        [buttonStack, genderLabel].forEach {
            addSubview($0)
        }
    }
    
    func setConstraints() {
        genderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        buttonStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(104.0/343.0)
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
