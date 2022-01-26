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
    
    //MARK: For Case = .datePicker
    let yearLabel = UILabel().then {
        $0.font = UIFont.title2_R16
        $0.textColor = UIColor.defaultBlack
        $0.text = "년"
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    let yearTextField = UITextField().then {
        $0.isUserInteractionEnabled = false
    }
    
    let monthLabel = UILabel().then {
        $0.font = UIFont.title2_R16
        $0.textColor = UIColor.defaultBlack
        $0.text = "월"
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    let monthTextField = UITextField().then {
        $0.isUserInteractionEnabled = false
    }
    
    let dayLabel = UILabel().then {
        $0.font = UIFont.title2_R16
        $0.textColor = UIColor.defaultBlack
        $0.text = "일"
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    let dayTextField = UITextField().then {
        $0.isUserInteractionEnabled = false
    }
    
    let dateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = UIScreen.main.bounds.width * 0.06
    }
    
    
    //MARK: Methods
    func makeBorder(layer: CALayer, view: UIView, color: UIColor, x: Double = 0, y: Double = 12, width: Double = 12) {
        layer.frame = CGRect(x: x, y: view.frame.height + y, width: view.frame.width + width, height: 1)
        layer.backgroundColor = color.cgColor
        view.layer.addSublayer(layer)
    }
    
    func makeBorder(view: UIView, color: UIColor, x: Double = 0, y: Double = 12, width: Double = 12) {
        let layer = CALayer()
        layer.frame = CGRect(x: x, y: view.frame.height + y, width: view.frame.width + width, height: 1)
        layer.backgroundColor = color.cgColor
        view.layer.addSublayer(layer)
    }
    
    func changeBorder(layer: CALayer, color: UIColor) {
        layer.backgroundColor = color.cgColor
    }
    
    func textFieldSetUp(textField: UITextField, color: UIColor = .gray7, text: String?) {
        guard let text = text else { return }
        let placeholderAttr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : color,
                                                                 NSAttributedString.Key.font : UIFont.title4_R14])
        
        textField.attributedPlaceholder = placeholderAttr
        textField.font = UIFont.title4_R14
        textField.textColor = UIColor.defaultBlack
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
    
    func birthConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        let yearView = UIView()
        let monthView = UIView()
        let dayView = UIView()
        
        yearView.addSubview(yearTextField)
        yearView.addSubview(yearLabel)
        monthView.addSubview(monthTextField)
        monthView.addSubview(monthLabel)
        dayView.addSubview(dayTextField)
        dayView.addSubview(dayLabel)
        
        dateStackView.addArrangedSubview(yearView)
        dateStackView.addArrangedSubview(monthView)
        dateStackView.addArrangedSubview(dayView)
        
        yearTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(yearLabel.snp.leading)
            make.top.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(yearTextField)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(monthLabel.snp.leading)
            make.top.equalToSuperview()
        }
        
        monthLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(yearTextField)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(dayLabel.snp.leading)
            make.top.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(yearTextField)
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
        
        switch inputViewType {
        case .timer:
            containerView.addSubview(timerLabel)
            addSubview(reRequestButton)
        case .datePicker:
            containerView.addSubview(dateStackView)
        case .gender:
            //MARK: 여기서부터 하면 됨
            print("gender")
        default:
            containerView.addSubview(leadingPadding)
            containerView.addSubview(textField)
        }
    }
    
    func setConstraints() {
        switch inputViewType {
        case .defaults:
            defaultsConstraints()
        case .timer:
            timerConstraints()
        case .datePicker:
            birthConstraints()
        default:
            print("error")
        }
    }
    
    
    //MARK: init
    convenience init(color: UIColor, text: String?, type: InputViewContentType) {
        self.init(frame: CGRect.zero)
        self.inputViewType = type
        textFieldSetUp(textField: textField, color: color, text: text)
        if type == .datePicker {
            textFieldSetUp(textField: yearTextField, text: "1990")
            textFieldSetUp(textField: monthTextField, text: "1")
            textFieldSetUp(textField: dayTextField, text: "1")
        }
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
        if inputViewType == .datePicker {
            makeBorder(view: yearTextField, color: .gray3, x: -12)
            makeBorder(view: monthTextField, color: .gray3, x: -12)
            makeBorder(view: dayTextField, color: .gray3, x: -12)
        } else {
            makeBorder(layer: bottomLine, view: containerView, color: .systemBackground)
        }
    }
}
