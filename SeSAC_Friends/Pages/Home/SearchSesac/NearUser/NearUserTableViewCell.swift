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
    
    func setUp() {
        addSubview(cardView)
    }
    
    func setConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
