//
//  CardViewButton.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/14.
//

import UIKit
import Then
import SnapKit

enum CardViewButtonType {
    case required
    case require
}

final class CardViewButton: UIButton, ViewRepresentable {
    
    var cardType: CardViewButtonType = .require {
        willSet {
            switch newValue {
            case .require:
                self.backgroundColor = .systemError
                
            case .required:
                self.backgroundColor = .systemSuccess
            }
        }
    }
    
    func setUp() {
        self.setTitleColor(.defaultWhite, for: .normal)
        self.titleLabel?.font = UIFont.title3_M14
        self.layer.cornerRadius = 8
    }
    
    func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
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
