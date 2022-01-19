//
//  AuthView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import UIKit
import Then
import SnapKit

enum AuthViewState {
    case request
    case logIn
}

class AuthView: UIView, ViewRepresentable {
    
    var authViewState: AuthViewState = .request
    let authRequestButton = H48Button()
    let phoneNumberTextField = InputTextField(color: .gray6, text: "휴대폰 번호(-없이 숫자만 입력)")
    
    let titleLabel = UILabel().then {
        $0.textColor = .defaultBlack
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let calloutLabel = UILabel().then {
        $0.textColor = .gray7
        $0.textAlignment = .center
    }
    
    func setUp() {
        addSubview(titleLabel)
        addSubview(authRequestButton)
        addSubview(phoneNumberTextField)
        
        if authViewState == .logIn {
            addSubview(calloutLabel)
        }
        
        self.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(168)
            make.centerX.equalToSuperview()
        }
        
        if authViewState == .logIn {
            calloutLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
            }
            phoneNumberTextField.snp.makeConstraints { make in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.height.equalTo(22)
                make.top.equalTo(calloutLabel.snp.bottom).offset(76)
            }
            
            authRequestButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        } else {
            phoneNumberTextField.snp.makeConstraints { make in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.height.equalTo(22)
                make.bottom.equalTo(titleLabel.snp.bottom).offset(99)
            }
            
            authRequestButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        titleLabel.textAlignment = .center
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
