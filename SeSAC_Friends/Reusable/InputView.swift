//
//  InputTextField.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import UIKit
import SnapKit
import Then

class InputView: UIView, ViewRepresentable {
    
    var textFieldState: TextFieldState = .inActive {
        willSet {
            print(newValue)
            switch newValue {
            case .inActive, .active:
                changeBorder(layer: bottomLine, color: .gray3)
            case .focus:
                changeBorder(layer: bottomLine, color: .systemFocus)
            case .error:
                changeBorder(layer: bottomLine, color: .systemError)
            case .success:
                changeBorder(layer: bottomLine, color: .systemSuccess)
            default:
                print("error")
            }
        }
    }
    
    var inputViewType: InputViewContentType?
    
    let containerView = UIView()
    let leadingPadding = UIView()
    let textField = UITextField()
    let bottomLine = CALayer()
    
    
    //MARK: For Case = .timer
    let timerLabel = UILabel().then {
        $0.font = UIFont.title3_M14
        $0.textColor = .brandGreen
        $0.text = "01:00"
    }
    
    let reRequestButton = H40Button().then {
        $0.buttonState = .fill
        $0.setTitle("재전송", for: .normal)
    }
    
    //MARK: Methods
    func makeBorder(layer: CALayer, view: UIView, color: UIColor) {
        layer.frame = CGRect(x: 0, y: view.frame.height + 12, width: view.frame.width + 12, height: 1)
        layer.backgroundColor = color.cgColor
        view.layer.addSublayer(layer)
    }
    
    func changeBorder(layer: CALayer, color: UIColor) {
        layer.backgroundColor = color.cgColor
    }
    
    func textFieldSetUp(color: UIColor, text: String?) {
        guard let text = text else { return }
        let placeholderAttr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : color,
                                                                 NSAttributedString.Key.font : UIFont.title4_R14])
        
        textField.attributedPlaceholder = placeholderAttr
        textField.font = UIFont.title4_R14
    }
    
    func defaultsConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        
        leadingPadding.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.leading.top.bottom.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(leadingPadding.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
    
    func timerConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        reRequestButton.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(containerView)
            make.width.equalTo(72)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(timerLabel.snp.leading)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(textField)
        }
    }
    
    func setUp() {
        self.addSubview(containerView)
        containerView.addSubview(leadingPadding)
        containerView.addSubview(textField)
        
        if inputViewType == .timer {
            containerView.addSubview(timerLabel)
            addSubview(reRequestButton)
        }
    }
    
    func setConstraints() {
        switch inputViewType {
        case .defaults:
            defaultsConstraints()
        case .timer:
            timerConstraints()
        default:
            print("error")
        }
    }
    
    
    //MARK: init
    convenience init(color: UIColor, text: String?, type: InputViewContentType) {
        self.init(frame: CGRect.zero)
        self.inputViewType = type
        textFieldSetUp(color: color, text: text)
        setUp()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        makeBorder(layer: bottomLine, view: containerView, color: .systemBackground)
    }
}
