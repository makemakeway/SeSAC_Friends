//
//  CancelPromiseView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/22.
//

import UIKit
import SnapKit
import Then

class MenuItemView: UIView, ViewRepresentable {
    var imageView = UIImageView(image: UIImage(asset: Asset.cancelMatch))
    var titleLabel = UILabel().then {
        $0.font = .title3_M14
        $0.textColor = .defaultBlack
        $0.textAlignment = .center
    }
    
    func setUp() {
        [imageView, titleLabel]
            .forEach { addSubview($0) }
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11).priority(.high)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-11)
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
