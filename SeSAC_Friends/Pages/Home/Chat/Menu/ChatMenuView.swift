//
//  ChatMenuView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/22.
//

import UIKit
import SnapKit
import Then

final class ChatMenuView: UIView, ViewRepresentable {
    
    private let menuStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
    }
    
    let reportView = MenuItemView().then {
        $0.titleLabel.text = "새싹 신고"
        $0.imageView.image = UIImage(asset: Asset.siren)
    }
    
    let cancelPromiseView = MenuItemView().then {
        $0.titleLabel.text = "약속 취소"
        $0.imageView.image = UIImage(asset: Asset.cancelMatch)
    }
    
    let addReviewView = MenuItemView().then {
        $0.titleLabel.text = "리뷰 등록"
        $0.imageView.image = UIImage(asset: Asset.write)
    }
    
    func setUp() {
        addSubview(menuStackView)
        menuStackView.backgroundColor = .defaultWhite
        
        [reportView, cancelPromiseView, addReviewView]
            .forEach { menuStackView.addArrangedSubview($0) }
        
        self.backgroundColor = .defaultBlack.withAlphaComponent(0.5)
    }
    
    func setConstraints() {
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
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
