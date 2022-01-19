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
    
    let containerView = UIView()
    let leadingPadding = UIView()
    let textField = UITextField()
    
    func setUp() {
        self.addSubview(containerView)
        containerView.addSubview(leadingPadding)
        containerView.addSubview(textField)
    }
    
    func textFieldSetUp(color: UIColor, text: String?) {
        guard let text = text else { return }
        let attr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : color,
                                                                 NSAttributedString.Key.font : UIFont.title4_R14])
        textField.attributedPlaceholder = attr
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
}
