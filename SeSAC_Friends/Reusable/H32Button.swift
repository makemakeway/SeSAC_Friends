//
//  H32Button.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit

enum H32Icon {
    case iconOn
    case iconOff
}

final class H32Button: UIButton, ViewRepresentable {
    var buttonState: ButtonState = .inactive {
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
            case .outline:
                self.setTitleColor(.brandGreen, for: .normal)
                self.tintColor = .brandGreen
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.brandGreen.cgColor
            case .fromUser:
                self.iconState = .iconOn
                self.setTitleColor(.brandGreen, for: .normal)
                self.tintColor = .brandGreen
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.brandGreen.cgColor
            case .fromServer:
                self.iconState = .iconOff
                self.setTitleColor(.systemError, for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.systemError.cgColor
            case .fromOtherUser:
                self.iconState = .iconOff
                self.setTitleColor(.defaultBlack, for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.gray4.cgColor
            default:
                print("error")
            }
        }
    }
    
    var iconState: H32Icon = .iconOff {
        willSet {
            switch newValue {
            case .iconOff:
                self.setImage(nil, for: .normal)
            case .iconOn:
                let image = UIImage(asset: Asset.closeSmall)
                let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                self.setImage(tintedImage, for: .normal)
                self.semanticContentAttribute = .forceRightToLeft
                self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            }
        }
    }
    
    func setUp() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.title4_R14
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(32)
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
