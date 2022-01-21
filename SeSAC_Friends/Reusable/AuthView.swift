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
    var inputTextField: InputTextField!
    
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
        switch state {
        case .request:
            titleLabel.setTextWithLineHeight(text: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요", lineHeight: 32, font: .display1_R20)
            inputTextField = InputTextField(color: .gray6, text: "휴대폰 번호(-없이 숫자만 입력)")
            inputTextField.textField.keyboardType = .numberPad
            authRequestButton.setTitle("인증 문자 받기", for: .normal)
        case .logIn:
            authRequestButton.buttonState = .disable
            titleLabel.setTextWithLineHeight(text: "인증번호가 문자로 전송되었어요", lineHeight: 32, font: .display1_R20)
            inputTextField = InputTextField(color: .gray6, text: "인증 번호 입력")
            inputTextField.textField.keyboardType = .numberPad
            calloutLabel.text = "(최대 소모 20초)"
            authRequestButton.setTitle("인증하고 시작하기", for: .normal)
        case .error:
            inputTextField = InputTextField(color: .systemError, text: "에러")
        }
    }
    
    func setUp() {
        addSubview(titleLabel)
        addSubview(authRequestButton)
        addSubview(inputTextField)
        
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
            inputTextField.snp.makeConstraints { make in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.height.equalTo(22)
                make.top.equalTo(calloutLabel.snp.bottom).offset(height * 0.09)
            }
            
            authRequestButton.snp.makeConstraints { make in
                make.top.equalTo(inputTextField.snp.bottom).offset(height * 0.1)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
            }
        } else {
            inputTextField.snp.makeConstraints { make in
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.height.equalTo(22)
                make.top.equalTo(titleLabel.snp.bottom).offset(height * 0.09)
            }
            
            authRequestButton.snp.makeConstraints { make in
                make.top.equalTo(inputTextField.snp.bottom).offset(height * 0.1)
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
        setUI(state: state)
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
