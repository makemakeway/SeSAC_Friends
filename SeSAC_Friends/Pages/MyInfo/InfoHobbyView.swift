//
//  InfoHobbyView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import Then
import SnapKit

class InfoHobbyView: UIView, ViewRepresentable {
    
    let hobbyLabel = UILabel().then {
        $0.font = .title4_R14
        $0.textColor = .defaultBlack
        $0.text = "자주 하는 취미"
    }
    
    func setUp() {
        
    }
    
    func setConstraints() {
        
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
