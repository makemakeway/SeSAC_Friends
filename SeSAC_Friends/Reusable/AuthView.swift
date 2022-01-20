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
    case error
}

class AuthView: UIView, ViewRepresentable {
    var authViewState: AuthViewState?
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
        $0.font = .title2_R16
    }
    
    func setUI(state: AuthViewState) {
//        switch state {
//        case .request:
//            
//        case .logIn:
//            <#code#>
//        case .error:
//            <#code#>
//        }
    }
    
    func setUp() {
        addSubview(titleLabel)
        addSubview(authRequestButton)
        addSubview(phoneNumberTextField)
        
        if authViewState != .request {
            addSubview(calloutLabel)
        }
        
        self.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        let height = UIScreen.main.bounds.height
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(height * 0.2)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        if authViewState == .logIn {
            calloutLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
            phoneNumberTextField.snp.makeConstraints { make in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.height.equalTo(22)
                make.top.equalTo(calloutLabel.snp.bottom).offset(height * 0.09)
            }
            
            authRequestButton.snp.makeConstraints { make in
                make.top.equalTo(phoneNumberTextField.snp.bottom).offset(height * 0.1)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        } else {
            phoneNumberTextField.snp.makeConstraints { make in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.height.equalTo(22)
                make.top.equalTo(titleLabel.snp.bottom).offset(height * 0.09)
            }
            
            authRequestButton.snp.makeConstraints { make in
                make.top.equalTo(phoneNumberTextField.snp.bottom).offset(height * 0.1)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        titleLabel.textAlignment = .center
    }
    
    convenience init(state: AuthViewState) {
        self.init(frame: CGRect.zero)
        self.authViewState = state
        setUp()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
