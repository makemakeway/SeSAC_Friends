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
    
    let sesacHobbyView = SesacHobbyView()

    
    let sesacReviewChevronImage = UIImageView(image: UIImage(asset: Asset.moreArrow))
    
    func setUp() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 24
        self.alignment = .center
        
        
        [sesacTitleView, sesacHobbyView].forEach {
            addArrangedSubview($0)
        }
        
        sesacTitleView.backgroundColor = .brandGreen
    }
    
    func setConstraints() {
        sesacTitleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        sesacHobbyView.snp.makeConstraints { make in
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
