//
//  CardView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit
import Then

enum CardViewType {
    case infoManage
    case searchSesac
}


final class CardView: UIView, ViewRepresentable {
    var cardViewType: CardViewType!
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 0
    }
    let cardImageView = CardImageView()
    let nicknameView = CardNicknameView()

    
    let cardStackView = CardStackView()
    
    func setUp() {
        addSubview(contentStackView)
        
        [cardImageView, nicknameView, cardStackView].forEach {
            contentStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardImageView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(194)
        }
        
        nicknameView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        cardStackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    convenience init(type: CardViewType) {
        self.init(frame: .zero)
        self.cardViewType = type
        setUp()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CardView: Expandable {
    func openOrClose(opened: Bool) {
        if opened {
            UIView.animate(withDuration: 0) { [weak self] in
                guard let self = self else { return }
                self.cardStackView.sesacTitleView.isHidden = false
                self.cardStackView.sesacReviewView.isHidden = false
                if self.cardViewType == .searchSesac {
                    self.cardStackView.sesacHobbyView.isHidden = false
                }
                self.nicknameView.chevronImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }
        } else {
            UIView.animate(withDuration: 0) { [weak self] in
                guard let self = self else { return }
                self.cardStackView.sesacTitleView.isHidden = true
                self.cardStackView.sesacReviewView.isHidden = true
                self.cardStackView.sesacHobbyView.isHidden = true
                self.nicknameView.chevronImageView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            }
        }
    }
}
