//
//  AuthViewButton.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import UIKit
import SnapKit

class H48Button: UIButton, ViewRepresentable {
    func setUp() {
        self.setTitleColor(.gray3, for: .disabled)
        self.setTitleColor(.white, for: .normal)
        self.setBackgroundColor(.gray6, for: .disabled)
        self.setBackgroundColor(.brandGreen, for: .normal)
        self.layer.cornerRadius = 10
    }
    
    func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
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
