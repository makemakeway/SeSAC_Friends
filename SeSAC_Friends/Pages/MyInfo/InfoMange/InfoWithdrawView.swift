//
//  InfoWithdrawView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import Then
import SnapKit

class InfoWithdrawView: UIView, ViewRepresentable {
    
    let withdrawLabel = UILabel().then {
        $0.font = .title4_R14
        $0.textColor = .defaultBlack
        $0.text = "회원 탈퇴"
    }
    
    func setUp() {
        addSubview(withdrawLabel)
    }
    
    func setConstraints() {
        withdrawLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
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
