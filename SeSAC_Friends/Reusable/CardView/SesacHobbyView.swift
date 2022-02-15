//
//  SesacHobbyView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/15.
//

import UIKit
import Then
import SnapKit

final class SesacHobbyView: UIView, ViewRepresentable {
    
    let sesacHobbyLabel = UILabel().then {
        $0.font = .title6_R12
        $0.textColor = .defaultBlack
        $0.text = "하고 싶은 취미"
    }
    let sesacHobbyStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    let testButton = H32Button().then {
        $0.setTitle("테스트", for: .normal)
        $0.buttonState = .outline
    }
    
    func setUp() {
        addSubview(sesacHobbyLabel)
        addSubview(sesacHobbyStackView)
        sesacHobbyStackView.addArrangedSubview(testButton)
    }
    
    func setConstraints() {
        sesacHobbyLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalTo(sesacHobbyStackView.snp.top).offset(-16)
        }
        
        sesacHobbyStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sesacHobbyLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
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
