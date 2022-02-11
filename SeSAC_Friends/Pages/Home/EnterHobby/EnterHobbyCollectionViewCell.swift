//
//  EnterHobbyCollectionViewCell.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/11.
//

import UIKit
import SnapKit

final class EnterHobbyCollectionViewCell: UICollectionViewCell, ViewRepresentable {
    
    var button = H32Button()
    
    func setUp() {
        self.backgroundColor = .magenta
        addSubview(button)
    }
    
    func setConstraints() {
        
        button.snp.makeConstraints { make in
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.sizeToFit()
        self.frame.size.width = button.frame.width + 32
        button.buttonState = .outline
        button.iconState = .iconOff
    }
    
}
