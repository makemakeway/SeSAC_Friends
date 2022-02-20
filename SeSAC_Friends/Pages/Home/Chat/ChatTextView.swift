//
//  ChatTextView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/21.
//

import UIKit
import SnapKit
import Then

final class ChatTextView: UIView, ViewRepresentable {
    
    let textView = UITextView().then {
        $0.backgroundColor = .gray1
        $0.font = .body3_R14
        $0.textColor = .defaultBlack
        $0.textAlignment = .justified
    }
    
    let sendButton = UIButton().then {
        $0.setImage(UIImage(asset: Asset.property1SendProperty2Inact), for: .normal)
    }
    
    lazy var placeholerLabel = UILabel().then {
        $0.font = .body3_R14
        $0.textColor = .gray7
        $0.text = placeholder
    }
    
    lazy var placeholder: String = "메세지를 입력하세요" {
        willSet {
            placeholerLabel.text = newValue
        }
    }
    
    func setUp() {
        [textView, sendButton, placeholerLabel]
            .forEach { addSubview($0) }
        
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        self.backgroundColor = .gray1
        self.layer.cornerRadius = 10
    }
    
    func setConstraints() {
        var height: CGFloat = 0
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            height = self.textView.contentSize.height
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-14)
            make.height.equalTo(height)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
        }
        
        placeholerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
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
