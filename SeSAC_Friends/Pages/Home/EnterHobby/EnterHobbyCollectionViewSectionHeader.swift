//
//  EnterHobbyCollectionViewSectionHeader.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/11.
//

import UIKit
import SnapKit
import Then

final class EnterHobbyCollectionViewSectionHeader: UICollectionReusableView, ViewRepresentable {
    
    let headerLabel = UILabel().then {
        $0.font = .title6_R12
        $0.textColor = .defaultBlack
    }
    
    func setUp() {
        addSubview(headerLabel)
    }
    
    func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
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


extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
