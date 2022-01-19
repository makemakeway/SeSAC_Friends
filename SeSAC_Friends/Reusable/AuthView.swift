//
//  AuthView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import UIKit
import Then
import SnapKit

class AuthView: UIView, ViewRepresentable {
    
    let authRequestButton = H48Button()
    let phoneNumberTextField = InputTextField(color: .gray6, text: "휴대폰 번호(-없이 숫자만 입력)")
    
    let titleLabel = UILabel().then {
        $0.textColor = .defaultBlack
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.setTextWithLineHeight(text: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요", lineHeight: 32, font: .display1_R20)
        $0.backgroundColor = .yellow
    }
    
    func setUp() {
        addSubview(titleLabel)
        addSubview(authRequestButton)
        addSubview(phoneNumberTextField)
        
        self.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(168)
            make.centerX.equalToSuperview()
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(22)
            make.bottom.equalTo(titleLabel.snp.bottom).offset(99)
        }
        
        authRequestButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
    }
    
    func makeBorder(view: UIView, color: UIColor) {
        let bottomLine = CALayer()
        
        view.backgroundColor = .yellow

        bottomLine.frame = CGRect(x: 0, y: view.frame.height + 12, width: view.frame.width, height: 1)

        bottomLine.backgroundColor = color.cgColor

        view.layer.addSublayer(bottomLine)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        makeBorder(view: phoneNumberTextField.textField, color: .gray6)
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
