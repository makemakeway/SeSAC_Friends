//
//  ChatView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class ChatView: UIView, ViewRepresentable {
    
    let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    let chatTextView = ChatTextView()
    
    let chatMenuView = ChatMenuView().then {
        $0.isHidden = true
        $0.layer.borderWidth = 0
    }
    
    let darkView = UIView().then {
        $0.backgroundColor = .defaultBlack.withAlphaComponent(0.5)
        $0.isHidden = true
    }
    
    var menuOpened = false
    
    func tableViewConfig() {
        tableView.register(ChatDateTableViewCell.self, forCellReuseIdentifier: ChatDateTableViewCell.useIdentifier)
        tableView.register(ChatNicknameTableViewCell.self, forCellReuseIdentifier: ChatNicknameTableViewCell.useIdentifier)
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.useIdentifier)
        tableView.register(OtherUserChatTableViewCell.self, forCellReuseIdentifier: OtherUserChatTableViewCell.useIdentifier)
    }
    
    func setUp() {
        [tableView, chatTextView, darkView, chatMenuView]
            .forEach { addSubview($0) }
        tableViewConfig()
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(chatTextView.snp.top)
        }
        
        chatTextView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        chatMenuView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        darkView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
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
