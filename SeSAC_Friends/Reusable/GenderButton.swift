//
//  GenderButton.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/28.
//

import UIKit
import Then
import SnapKit

class GenderButton: UIButton, ViewRepresentable {
    var gender: Bool?
    
    var isClicked: Bool = false {
        willSet {
            switch newValue {
            case true:
                self.backgroundColor = .brandWhiteGreen
            case false:
                self.backgroundColor = .systemBackground
            }
        }
    }
    
    let markImageView = UIImageView()
    let genderLabel = UILabel().then {
        $0.font = UIFont.title2_R16
        $0.textColor = UIColor.defaultBlack
    }
    let containerView = UIView()
    
    func setUp() {
        guard let gender = gender else {
            print("gender Missing")
            return
        }
        addSubview(containerView)
        
        containerView.addSubview(markImageView)
        containerView.addSubview(genderLabel)
        containerView.isUserInteractionEnabled = false

        markImageView.setContentHuggingPriority(.required, for: .vertical)
        
        if gender {
            let markImage = UIImage(asset: Asset.man)
            markImageView.image = markImage
            genderLabel.text = "남자"
        } else {
            let markImage = UIImage(asset: Asset.woman)
            markImageView.image = markImage
            genderLabel.text = "여자"
        }
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray3.cgColor
        self.layer.borderWidth = 1
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        markImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-14)
            make.centerX.equalToSuperview()
        }
        
        genderLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(markImageView.snp.bottom).offset(2)
            make.bottom.lessThanOrEqualTo(-14)
        }
    }
    
    convenience init(gender: Bool) {
        self.init(frame: .zero)
        self.gender = gender
        setUp()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
