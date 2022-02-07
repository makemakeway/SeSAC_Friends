//
//  FloatingButton.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/07.
//

import UIKit

enum FloatingButtonState {
    case normal
    case matching
    case matched
}

final class FloatingButton: UIButton, ViewRepresentable {
    
    var floatingButtonState: FloatingButtonState = .normal {
        willSet {
            switch newValue {
            case .normal:
                self.setImage(UIImage(asset: Asset.search), for: .normal)
            case .matched:
                self.setImage(UIImage(asset: Asset.antenna), for: .normal)
            case .matching:
                self.setImage(UIImage(asset: Asset.message), for: .normal)
            }
        }
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
