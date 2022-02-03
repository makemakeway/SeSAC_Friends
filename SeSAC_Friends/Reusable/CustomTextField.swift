//
//  CustomTextField.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit
import Then

class CustomTextField: UIView, ViewRepresentable {
    var textFieldState: TextFieldState = .inActive {
        willSet {
            print(newValue)
            switch newValue {
            case .inActive, .active:
                changeBorder(layer: bottomLine, color: .gray3)
            case .focus:
                changeBorder(layer: bottomLine, color: .systemFocus)
            default:
                print("error")
            }
        }
    }
    
    let textField = UITextField().then {
        $0.font = .title4_R14
        $0.textColor = .defaultBlack
    }
    
    let bottomLine = CALayer()
    var bottomLineAdded = false
    
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
        let placeholderAttr = NSAttributedString(string: text,
                                                 attributes: [
                                                    NSAttributedString.Key.foregroundColor : color,
                                                    NSAttributedString.Key.font : UIFont.title4_R14])
        
        textField.attributedPlaceholder = placeholderAttr
        textField.font = UIFont.title4_R14
        textField.textColor = UIColor.defaultBlack
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
    
    func setUp() {
        addSubview(textField)
    }
    
    func setConstraints() {
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.trailing.top.bottom.equalToSuperview()
        }
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        setUp()
        setConstraints()
        textFieldSetUp(textField: textField, text: placeholder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !(bottomLineAdded) {
            makeBorder(layer: bottomLine, view: self, color: .systemBackground, x: 0, y: 0, width: 1)
            bottomLineAdded = true
        }
    }
}
