//
//  InputTextField.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import UIKit
import SnapKit
import Then
import SwiftUI

class InputTextField: UIView, ViewRepresentable {
    
    var textFieldState: TextFieldState = .inActive {
        willSet {
            switch newValue {
            case .inActive, .active:
                changeBorder(layer: bottomLine, color: .systemBackground)
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
    
    var placeHolderText: String = ""
    
    let containerView = UIView()
    let leadingPadding = UIView()
    let textField = UITextField()
    let bottomLine = CALayer()
    
    func makeBorder(layer: CALayer, view: UIView, color: UIColor) {
        layer.frame = CGRect(x: 0, y: view.frame.height + 12, width: view.frame.width, height: 1)
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
    
    func setUp() {
        self.addSubview(containerView)
        containerView.addSubview(leadingPadding)
        containerView.addSubview(textField)
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    convenience init(color: UIColor, text: String?) {
        self.init(frame: CGRect.zero)
        textFieldSetUp(color: color, text: text)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        makeBorder(layer: bottomLine, view: containerView, color: .systemBackground)
    }
}
