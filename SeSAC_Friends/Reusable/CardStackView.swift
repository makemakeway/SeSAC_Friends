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
        $0.numberOfLines = 0
    }
    
    let sesacHobbyView = UIView()
    let sesacHobbyLabel = UILabel().then {
        $0.font = .title6_R12
        $0.textColor = .defaultBlack
        $0.text = "하고 싶은 취미"
    }
    let sesacHobbyStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    let testButton = H32Button().then {
        $0.setTitle("테스트", for: .normal)
        $0.buttonState = .outline
        $0.sizeToFit()
    }
    
    let sesacReviewChevronImage = UIImageView(image: UIImage(asset: Asset.moreArrow))
    
    func setUp() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 24
        self.alignment = .center
        
        sesacTitleView.addSubview(sesacTitleLabel)
        sesacTitleView.addSubview(titleStackView)
        
        sesacHobbyView.addSubview(sesacHobbyLabel)
        sesacHobbyView.addSubview(sesacHobbyStackView)
        
        sesacReviewView.addSubview(sesacReviewLabel)
        sesacReviewView.addSubview(sesacReviewContentLabel)
        sesacReviewView.addSubview(sesacReviewChevronImage)
        
        [sesacTitleView, sesacHobbyView,sesacReviewView].forEach {
            addArrangedSubview($0)
        }
        
        sesacHobbyStackView.addArrangedSubview(testButton)
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
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(sesacTitleLabel.snp.bottom).offset(16)
        }
        
        sesacHobbyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        sesacHobbyLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        sesacHobbyStackView.snp.makeConstraints { make in
            make.top.equalTo(sesacHobbyLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        sesacReviewView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sesacReviewLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        sesacReviewChevronImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-3)
            make.centerY.equalTo(sesacReviewLabel.snp.centerY)
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
        sesacTitleView.isHidden = true
        sesacHobbyView.isHidden = true
        sesacReviewView.isHidden = true
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
