//
//  ChatNicknameTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class ChatNicknameTableViewCell: UITableViewCell, ViewRepresentable {
    
    let nicknameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 4
    }
    
    let nicknameLabel = UILabel().then {
        $0.font = .title3_M14
        $0.textColor = .gray7
    }
    
    private let bellImageView = UIImageView().then {
        $0.image = UIImage(asset: Asset.bell)
    }
    
    private let subtextLabel = UILabel().then {
        $0.font = .title4_R14
        $0.textColor = .gray6
        $0.text = "채팅을 통해 약속을 정해보세요 :)"
    }
    
    func setUp() {
        [bellImageView, nicknameLabel]
            .forEach { nicknameStackView.addArrangedSubview($0) }
        
        [nicknameStackView, subtextLabel]
            .forEach { contentView.addSubview($0) }
    }
    
    func setConstraints() {
        nicknameStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(subtextLabel.snp.top).offset(-2)
        }
        
        bellImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
        }
        
        subtextLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameStackView.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
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
