//
//  AlertView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/05.
//

import UIKit
import SnapKit
import Then

class AlertView: UIView, ViewRepresentable {
    
    let contentView = UIView().then {
        $0.backgroundColor = .defaultWhite
        $0.layer.cornerRadius = 16
    }
    let cancelButton = H48Button().then {
        $0.buttonState = .inactive
        let attr = NSAttributedString(string: "취소", attributes: [NSAttributedString.Key.font: UIFont.body3_R14])
        $0.setAttributedTitle(attr, for: .normal)
    }
    let okButton = H48Button().then {
        $0.buttonState = .fill
        let attr = NSAttributedString(string: "확인", attributes: [NSAttributedString.Key.font: UIFont.body3_R14])
        $0.setAttributedTitle(attr, for: .normal)
    }
    
    let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    let mainTitleLabel = UILabel().then {
        $0.font = UIFont.body1_M16
        $0.textColor = .defaultBlack
        $0.textAlignment = .center
    }
    
    let subtextLabel = UILabel().then {
        $0.font = UIFont.title4_R14
        $0.textColor = .defaultBlack
        $0.textAlignment = .center
    }
    
    func setUp() {
        addSubview(contentView)
        [buttonStackView, mainTitleLabel, subtextLabel]
            .forEach {
                contentView.addSubview($0)
            }
        [cancelButton, okButton]
            .forEach {
                buttonStackView.addArrangedSubview($0)
            }
        
        self.backgroundColor = .defaultBlack.withAlphaComponent(0.5)
        
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        subtextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(mainTitleLabel)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subtextLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(mainTitleLabel)
            make.bottom.equalToSuperview().offset(-16)
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
