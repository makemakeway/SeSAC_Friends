//
//  FilterButton.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/07.
//

import UIKit
import Then

final class FilterButton: UIButton, ViewRepresentable {
    var buttonState: ButtonState = .disable {
        willSet {
            switch newValue {
            case .fill:
                self.setTitleColor(.defaultWhite, for: .normal)
                self.backgroundColor = .brandGreen
                self.clipsToBounds = true
            default:
                self.setTitleColor(.defaultBlack, for: .normal)
                self.backgroundColor = .defaultWhite
                self.clipsToBounds = true
            }
        }
    }
    
    func setUp() {
        self.titleLabel?.font = .title3_M14
    }
    
    func setConstraints() {
        
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
