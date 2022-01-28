//
//  GenderButton.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/28.
//

import UIKit
import Then
import SnapKit

class GenderButtonView: UIButton, ViewRepresentable {
    var gender: Bool?
    
    let markImageView = UIImageView()
    let genderLabel = UILabel().then {
        $0.font = UIFont.title2_R16
        $0.textColor = UIColor.defaultBlack
    }
    
    func setUp() {
        guard let gender = gender else {
            print("gender Missing")
            return
        }
        
        addSubview(markImageView)
        addSubview(genderLabel)

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
        markImageView.backgroundColor = .defaultWhite
        self.backgroundColor = .brandYellowGreen
    }
    
    func setConstraints() {
        markImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(14)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(markImageView.snp.bottom).offset(2)
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
