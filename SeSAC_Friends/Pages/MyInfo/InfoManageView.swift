//
//  InfoManageView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/02.
//

import UIKit
import SnapKit

class InfoManageView: UIView, ViewRepresentable {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let cardView = CardView()
    let infoStackView = InfoStackView()

    func setUp() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardView)
        contentView.addSubview(infoStackView)
        self.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.top.bottom.width.equalToSuperview()
        }
        
        cardView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-54)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
