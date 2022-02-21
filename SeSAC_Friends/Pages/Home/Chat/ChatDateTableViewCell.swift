//
//  ChatDateTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class ChatDateTableViewCell: UITableViewCell, ViewRepresentable {
    
    let containerView = UIView().then {
        $0.backgroundColor = .gray7
        $0.layer.cornerRadius = 14
    }
    
    let dateLabel = UILabel().then {
        $0.font = .title5_M12
        $0.textColor = .defaultWhite
    }
    
    func setUp() {
        containerView.addSubview(dateLabel)
        contentView.addSubview(containerView)
    }
    
    func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
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
