//
//  CardView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit

class CardView: UIView, ViewRepresentable {
    
    let contentView = UIView()
    let cardImageView = CardImageView()
    let nicknameView = UIView()
    let nicknameLabel = UILabel().then {
        $0.font = .title1_M16
        $0.textColor = .defaultBlack
        $0.text = UserInfo.nickname
    }
    let chevronImageView = UIImageView(image: UIImage(asset: Asset.moreArrow)).then {
        $0.transform = CGAffineTransform(rotationAngle: -.pi / 2)
    }
    
    let cardStackView = CardStackView()
    
    func setUp() {
        addSubview(contentView)
        
        [cardImageView, nicknameView, cardStackView].forEach {
            contentView.addSubview($0)
        }
        
        nicknameView.addSubview(nicknameLabel)
        nicknameView.addSubview(chevronImageView)
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardImageView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(194)
        }
        
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-18)
        }
        
        cardStackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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

extension CardView: Expandable {
    func openOrClose(opened: Bool) {
        if opened {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self = self else { return }
                self.cardStackView.sesacTitleView.isHidden = false
                self.cardStackView.sesacReviewView.isHidden = false
                self.chevronImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }
            
        } else {
            UIView.animate(withDuration: 0.1) { [weak self] in
                guard let self = self else { return }
                self.cardStackView.sesacTitleView.isHidden = true
                self.cardStackView.sesacReviewView.isHidden = true
                self.chevronImageView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            }
        }
    }
}
