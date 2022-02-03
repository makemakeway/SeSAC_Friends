//
//  CardImageView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit

class CardImageView: UIView, ViewRepresentable {
    
    let backgroundImage = UIImageView(image: UIImage(asset: Asset.sesacBackground1))
    let sesacImage = UIImageView(image: UIImage(asset: Asset.sesacFace1))
    
    func setUp() {
        [backgroundImage].forEach {
            addSubview($0)
        }
        backgroundImage.addSubview(sesacImage)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func setConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacImage.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
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
