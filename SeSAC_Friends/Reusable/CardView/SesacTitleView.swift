//
//  SesacTitleView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/15.
//

import UIKit
import SnapKit
import Then

final class SesacTitleView: UIView, ViewRepresentable {
    
    let sesacTitleLabel = UILabel().then {
        $0.font = .title6_R12
        $0.textColor = .defaultBlack
        $0.text = "새싹 타이틀"
    }
    
    let titleStackView = TitleStackView()
    
    func setUp() {
        addSubview(sesacTitleLabel)
        addSubview(titleStackView)
    }
    
    func setConstraints() {
        sesacTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(titleStackView.snp.top).offset(-16)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(sesacTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
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
