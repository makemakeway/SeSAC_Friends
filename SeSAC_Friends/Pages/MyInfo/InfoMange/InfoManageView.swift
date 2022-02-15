//
//  InfoManageView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/02.
//

import UIKit
import SnapKit
import Then

class InfoManageView: UIView, ViewRepresentable {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    let cardView = CardView(type: .infoManage)
    let infoStackView = InfoStackView()

    func setUp() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        [cardView, infoStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
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
        
        stackView.snp.makeConstraints { make in
            make.centerX.top.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-54)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
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
