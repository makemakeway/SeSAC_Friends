//
//  NearUserTableViewCell.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class NearUserTableViewCell: UITableViewCell, ViewRepresentable {
    
    let cardView = CardView(type: .searchSesac)
    let cardViewButton = CardViewButton()
    var disposeBag = DisposeBag()
    var opened = false
    
    var cardViewButtonClicked : Observable<Void>{
        return self.cardViewButton.rx.tap
            .asObservable()
    }
    
    func setUp() {
        contentView.addSubview(cardView)
        contentView.addSubview(cardViewButton)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.opened = false
        let titleView = self.cardView.cardStackView.sesacTitleView.titleStackView
        titleView.exactTimeButton.buttonState = .inactive
        titleView.fastResponseButton.buttonState = .inactive
        titleView.goodTimeButton.buttonState = .inactive
        titleView.greatJobButton.buttonState = .inactive
        titleView.kindnessButton.buttonState = .inactive
        titleView.goodMannerButton.buttonState = .inactive
        let reviewView = cardView.cardStackView.sesacReviewView
        reviewView.sesacReviewChevronImage.isHidden = true
        reviewView.sesacReviewContentLabel.textColor = .gray6
        
        disposeBag = DisposeBag()
    }
}
