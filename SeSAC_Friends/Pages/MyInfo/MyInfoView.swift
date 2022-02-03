//
//  MyInfoView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/02.
//

import SnapKit
import UIKit

class MyInfoView: UIView, ViewRepresentable {
    
    let tableView = UITableView()
    
    func setUp() {
        addSubview(tableView)
        self.backgroundColor = .systemBackground
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
