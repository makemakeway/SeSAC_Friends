//
//  InfoStackView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit
import Then

class InfoStackView: UIStackView, ViewRepresentable {
    let genderView = InfoGenderView()
    
    func setUp() {
        self.axis = .vertical
        self.alignment = .center
        self.spacing = 10
        
        [genderView].forEach {
            addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        genderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
