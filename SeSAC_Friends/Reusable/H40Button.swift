//
//  H40Button.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/22.
//

import UIKit

class H40Button: UIButton, ViewRepresentable {
    
    var buttonState: ButtonState = .disable {
        willSet {
            switch newValue {
            case .fill:
                self.tintColor = .defaultWhite
                self.backgroundColor = .brandGreen
            case .disable:
                self.tintColor = .gray3
                self.backgroundColor = .gray6
            default:
                print("error")
            }
        }
    }
    
    func setUp() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.body3_R14
    }
    
    func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
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
