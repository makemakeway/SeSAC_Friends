//
//  NearUserView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/14.
//

import UIKit
import Then
import SnapKit

final class NearUserView: UIView, ViewRepresentable {
    
    let tableView = UITableView()
    
    func setUp() {
        addSubview(tableView)
        tableView.register(NearUserTableViewCell.self, forCellReuseIdentifier: NearUserTableViewCell.useIdentifier)
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
