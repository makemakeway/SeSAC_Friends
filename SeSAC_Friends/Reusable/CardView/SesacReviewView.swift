//
//  SesacReviewView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/15.
//

import Foundation
import UIKit

final class SesacReviewView: UIView, ViewRepresentable {
    
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
    
    let sesacReviewChevronImage = UIButton().then {
        $0.setImage(UIImage(asset: Asset.moreArrow), for: .normal)
    }
    
    func setUp() {
        addSubview(sesacReviewLabel)
        addSubview(sesacReviewContentLabel)
        addSubview(sesacReviewChevronImage)
    }
    
    func setConstraints() {
        sesacReviewLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        sesacReviewChevronImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.size.equalTo(16)
            make.centerY.equalTo(sesacReviewLabel.snp.centerY)
        }
        
        sesacReviewContentLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacReviewLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-54)
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
