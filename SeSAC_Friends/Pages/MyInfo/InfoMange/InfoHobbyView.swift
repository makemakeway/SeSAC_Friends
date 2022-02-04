//
//  InfoHobbyView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import Then
import SnapKit

class InfoHobbyView: UIView, ViewRepresentable {
    
    let hobbyLabel = UILabel().then {
        $0.font = .title4_R14
        $0.textColor = .defaultBlack
        $0.text = "자주 하는 취미"
    }
    
    let hobbyTextField = CustomTextField(placeholder: "취미를 입력해주세요.")
    
    func setUp() {
        addSubview(hobbyLabel)
        addSubview(hobbyTextField)
    }
    
    func setConstraints() {
        hobbyLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        hobbyTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(164.0/343.0)
            make.height.equalTo(48)
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
