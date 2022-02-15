//
//  EmptyUserView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/16.
//

import UIKit
import SnapKit
import Then

final class EmptyUserView: UIView, ViewRepresentable {
    
    private let contentView = UIView()
    private let imageView = UIImageView().then {
        $0.image = UIImage(asset: Asset.img2)
    }
    
    private var mainLabel = UILabel().then {
        $0.font = .display1_R20
        $0.textColor = .defaultBlack
        $0.text = "아쉽게도 주변에 새싹이 없어요ㅠ"
        $0.textAlignment = .center
    }
    
    private var subLabel = UILabel().then {
        $0.font = .title4_R14
        $0.textColor = .gray7
        $0.text = "취미를 변경하거나 조금만 더 기다려주세요!"
        $0.textAlignment = .center
    }
    
    let changeHobbyButton = H48Button().then {
        $0.setTitle("취미 변경하기", for: .normal)
        $0.buttonState = .fill
    }
    
    let refreshButton = H48Button().then {
        let image = UIImage(asset: Asset.vector)
        $0.setImage(image, for: .normal)
        $0.buttonState = .outline
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.brandGreen.cgColor
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    func setUp() {
        addSubview(contentView)
        addSubview(buttonStackView)
        
        [imageView, mainLabel, subLabel].forEach {
            contentView.addSubview($0)
        }
        
        [changeHobbyButton, refreshButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(315.0/339.0)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
            make.size.equalTo(64)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
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
