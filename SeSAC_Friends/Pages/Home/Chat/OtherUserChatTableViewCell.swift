//
//  OtherUserChatTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class OtherUserChatTableViewCell: UITableViewCell, ViewRepresentable {
    
    private let chatContainerView = UIView().then {
        $0.layer.borderColor = UIColor.gray4.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    let chatLabel = UILabel().then {
        $0.font = .body3_R14
        $0.textColor = .defaultBlack
        $0.numberOfLines = 0
    }
    
    let timeLabel = UILabel().then {
        $0.font = .title6_R12
        $0.textColor = .gray6
    }
    
    func setUp() {
        [chatContainerView, timeLabel]
            .forEach { contentView.addSubview($0) }
        
        chatContainerView.addSubview(chatLabel)
    }
    
    func setConstraints() {
        chatLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(chatContainerView)
            make.leading.equalTo(chatContainerView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        chatContainerView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-(UIScreen.main.bounds.width * 111 / 375))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }}
