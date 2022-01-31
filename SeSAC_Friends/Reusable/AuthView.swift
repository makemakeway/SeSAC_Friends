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
    case nickName
    case birthDay
    case email
    case gender
}

final class AuthView: UIView, ViewRepresentable {
    var authViewState: AuthViewState?
    let authRequestButton = H48Button()
    var authInputView: InputView!
    let height = UIScreen.main.bounds.height
    
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
    
    let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko-KR")
        $0.maximumDate = Date()
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: Locale.current.identifier)
        calendar.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        var components = DateComponents()
        components.year = 1990
        components.month = 1
        components.day = 1
        let defaultDate = calendar.date(from: components)
        $0.date = defaultDate ?? Date()
    }
    
    let spacing = UIView()
    
    func makeUI(title: String, placeholder: String, buttonTitle: String, type: InputViewContentType) {
        titleLabel.setTextWithLineHeight(text: title, lineHeight: 32, font: .display1_R20)
        authInputView = InputView(color: .gray6, text: placeholder, type: type)
        authRequestButton.setTitle(buttonTitle, for: .normal)
        authRequestButton.buttonState = .disable
    }
    
    func makeUI(title: String, placeholder: String, buttonTitle: String, type: InputViewContentType, callout: String) {
        authRequestButton.buttonState = .disable
        addSubview(calloutLabel)
        calloutLabel.text = callout
        titleLabel.setTextWithLineHeight(text: title, lineHeight: 32, font: .display1_R20)
        authInputView = InputView(color: .gray6, text: placeholder, type: type)
        authRequestButton.setTitle(buttonTitle, for: .normal)
    }
    
    func birthUI(title: String, buttonTitle: String) {
        titleLabel.setTextWithLineHeight(text: title, lineHeight: 32, font: .display1_R20)
        authInputView = InputView(color: .gray6, text: "1990", type: .datePicker)
        authRequestButton.setTitle(buttonTitle, for: .normal)
        authRequestButton.buttonState = .disable
    }
    
    func genderUI(title: String, buttonTitle: String) {
        titleLabel.setTextWithLineHeight(text: title, lineHeight: 32, font: .display1_R20)
        authInputView = InputView(color: .gray6, text: "1990", type: .gender)
        authRequestButton.setTitle(buttonTitle, for: .normal)
        authRequestButton.buttonState = .disable
    }
    
    func setUI(state: AuthViewState) {
        switch state {
        case .request:
            makeUI(title: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해주세요",
                   placeholder: "휴대폰 번호(-없이 숫자만 입력)",
                   buttonTitle: "인증 문자 받기",
                   type: .defaults)
            authInputView.textField.keyboardType = .numberPad
        case .logIn:
            makeUI(title: "인증번호가 문자로 전송되었어요",
                   placeholder: "인증번호 입력",
                   buttonTitle: "인증하고 시작하기",
                   type: .timer,
                   callout: "(최대 20초 소요)")
            authInputView.textField.keyboardType = .numberPad
        case .nickName:
            makeUI(title: "닉네임을 입력해주세요",
                   placeholder: "10자 이내로 입력",
                   buttonTitle: "다음",
                   type: .defaults)
        case .birthDay:
            addSubview(datePicker)
            birthUI(title: "생년월일을 알려주세요", buttonTitle: "다음")
        case .email:
            makeUI(title: "이메일을 입력해주세요",
                   placeholder: "SeSAC@email.com",
                   buttonTitle: "다음",
                   type: .defaults,
                   callout: "휴대폰 번호 변경 시 인증을 위해 사용해요")
        case .gender:
            makeUI(title: "성별을 선택해주세요",
                   placeholder: "",
                   buttonTitle: "다음",
                   type: .gender,
                   callout: "새싹 찾기 기능을 이용하기 위해서 필요해요")
        case .error:
            authInputView = InputView(color: .systemError, text: "에러", type: .defaults)
        }
    }
    
    func setUp() {
        addSubview(titleLabel)
        addSubview(authRequestButton)
        addSubview(authInputView)
        addSubview(spacing)
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        calloutLabel.setContentHuggingPriority(.required, for: .vertical)
        self.backgroundColor = .systemBackground
    }
    
    func setCalloutConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.top.lessThanOrEqualTo(height * 0.206)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        calloutLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8).priority(.required)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func setLoginConstraints() {
        authRequestButton.snp.makeConstraints { make in
            make.top.equalTo(authInputView.snp.bottom).offset(height * 0.1)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func setBirthdayConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(height * 0.206)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(height * 0.266)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    
    func setNicknameConstraints() {
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(height * 0.206)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func setCommonConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(authRequestButton.snp.top).offset(-height * 0.226)
        }
        
        authInputView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(height * 0.09)
            make.height.equalTo(48)
        }
        
        //MARK: 버튼이 기준점
        authRequestButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(height * 0.513).priority(.required)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func setGenderConstraints() {
        authInputView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            
            make.bottom.equalTo(authRequestButton.snp.top).offset(-32)
            make.top.equalTo(calloutLabel.snp.bottom).offset(32)
        }
    }
    
    func setConstraints() {
        setCommonConstraints()
        
        switch authViewState {
        case .logIn:
            setLoginConstraints()
            setCalloutConstraints()
        case .birthDay:
            setBirthdayConstraints()
            print("Birthday")
        case .nickName:
            setNicknameConstraints()
            print("nickname")
        case .email:
            print("email")
            setCalloutConstraints()
        case .gender:
            setCalloutConstraints()
            setGenderConstraints()
            print("gender")
        default:
            return
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
