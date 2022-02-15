//
//  TitleStackView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import SnapKit
import Then

class TitleStackView: UIStackView, ViewRepresentable {
    
    let firstHStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    let secondHStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    let thirdHStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    let goodMannerButton = H32Button().then {
        $0.setTitle("좋은 매너", for: .normal)
        $0.buttonState = .inactive
    }
    
    let exactTimeButton = H32Button().then {
        $0.setTitle("정확한 시간 약속", for: .normal)
        $0.buttonState = .inactive
    }
    
    let fastResponseButton = H32Button().then {
        $0.setTitle("빠른 응답", for: .normal)
        $0.buttonState = .inactive
    }
    
    let kindnessButton = H32Button().then {
        $0.setTitle("친절한 성격", for: .normal)
        $0.buttonState = .inactive
    }
    
    let greatJobButton = H32Button().then {
        $0.setTitle("능숙한 취미 실력", for: .normal)
        $0.buttonState = .inactive
    }
    
    let goodTimeButton = H32Button().then {
        $0.setTitle("유익한 시간", for: .normal)
        $0.buttonState = .inactive
    }
    
    func setUp() {
        self.axis = .vertical
        self.spacing = 8
        self.distribution = .fillEqually
        
        [firstHStack, secondHStack, thirdHStack].forEach {
            addArrangedSubview($0)
        }
        
        [goodMannerButton, exactTimeButton].forEach {
            firstHStack.addArrangedSubview($0)
        }
        
        [fastResponseButton, kindnessButton].forEach {
            secondHStack.addArrangedSubview($0)
        }
        
        [greatJobButton, goodTimeButton].forEach {
            thirdHStack.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setConstraints()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
