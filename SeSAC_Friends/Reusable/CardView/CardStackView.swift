//
//  CardStackView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit

class CardStackView: UIStackView, ViewRepresentable {
    
    let sesacTitleView = SesacTitleView()
    let sesacHobbyView = SesacHobbyView()
    let sesacReviewView = SesacReviewView()
    
    func setUp() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 24
        self.alignment = .center
        
        [sesacTitleView, sesacHobbyView, sesacReviewView].forEach {
            addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        sesacTitleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        sesacHobbyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        sesacReviewView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setConstraints()
        sesacTitleView.isHidden = true
        sesacHobbyView.isHidden = true
        sesacReviewView.isHidden = true
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
