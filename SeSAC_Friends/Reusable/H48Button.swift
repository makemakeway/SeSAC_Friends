//
//  AuthViewButton.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class H48Button: UIButton, ViewRepresentable {
    
    var buttonState: ButtonState = .disable {
        willSet {
            switch newValue {
            case .fill:
                self.setTitleColor(.defaultWhite, for: .normal)
                self.backgroundColor = .brandGreen
                self.layer.borderWidth = 0
            case .disable:
                self.setTitleColor(.gray3, for: .normal)
                self.backgroundColor = .gray6
                self.layer.borderWidth = 0
            case .inactive:
                self.setTitleColor(.defaultBlack, for: .normal)
                self.backgroundColor = .systemBackground
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
            default:
                print("error")
            }
        }
    }
    
    func setUp() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.body3_R14
    }
    
    func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
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
