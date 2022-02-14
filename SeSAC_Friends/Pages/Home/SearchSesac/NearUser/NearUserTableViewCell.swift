//
//  NearUserTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/14.
//

import UIKit
import SnapKit

final class NearUserTableViewCell: UITableViewCell, ViewRepresentable {
    
    let cardView = CardView()
    let cardViewButton = CardViewButton()
    
    func setUp() {
        addSubview(cardView)
        addSubview(cardViewButton)
        self.selectionStyle = .none
        cardViewButton.setTitle("요청하기", for: .normal)
        cardViewButton.cardType = .require
    }
    
    func setConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        cardViewButton.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).offset(12)
            make.trailing.equalTo(cardView.snp.trailing).offset(-12)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
