//
//  EnterHobbyView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/10.
//

import UIKit
import SnapKit
import Then

final class EnterHobbyView: UIView, ViewRepresentable {
    
    func setUp() {
        self.backgroundColor = .systemBackground
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
