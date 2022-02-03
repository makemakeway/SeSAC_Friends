//
//  CardStackView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit

class CardStackView: UIStackView, ViewRepresentable {
    
    let sesacTitleView = UIView()
    let sesacTitleLabel = UILabel().then {
        $0.font = .title6_R12
        $0.textColor = .defaultBlack
        $0.text = "새싹 타이틀"
    }
    
    let titleStackView = TitleStackView()
    
    let sesacReviewView = UIView()
    let sesacReviewLabel = UILabel().then {
        $0.font = .title6_R12
        $0.textColor = .defaultBlack
        $0.text = "새싹 리뷰"
    }
    let sesacReviewContentLabel = UILabel().then {
        $0.font = .body3_R14
        $0.textColor = .gray6
        $0.text = "첫 리뷰를 기다리는 중이에요!"
    }
    
    func setUp() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 24
        self.alignment = .center
        
        sesacTitleView.addSubview(sesacTitleLabel)
        sesacTitleView.addSubview(titleStackView)
        
        sesacReviewView.addSubview(sesacReviewLabel)
        sesacReviewView.addSubview(sesacReviewContentLabel)
        
        [sesacTitleView, sesacReviewView].forEach {
            addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        sesacTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        sesacTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sesacTitleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
        
        sesacReviewView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sesacReviewLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        sesacReviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
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
