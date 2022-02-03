//
//  InfoAgeRestrictView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/03.
//

import UIKit
import Then
import SnapKit
import MultiSlider

class InfoAgeRestrictView: UIView, ViewRepresentable {
    
    let ageRestrictLabel = UILabel().then {
        $0.font = .title4_R14
        $0.textColor = .defaultBlack
        $0.text = "상대방 연령대"
    }
    
    let ageRangeLabel = UILabel().then {
        $0.font = .title3_M14
        $0.textColor = .brandGreen
        $0.text = "18 - 65"
    }
    
    let slider = MultiSlider().then {
        $0.minimumValue = 18
        $0.maximumValue = 65
        $0.value = [18, 35]
        $0.outerTrackColor = .gray2
        $0.tintColor = .brandGreen
        $0.isVertical = false
        $0.orientation = .horizontal
        $0.snapStepSize = 1
        $0.thumbImage = UIImage(asset: Asset.filterControl)
    }
    
    let labelView = UIView()
    
    func setUp() {
        addSubview(labelView)
        labelView.addSubview(ageRestrictLabel)
        labelView.addSubview(ageRangeLabel)
        addSubview(slider)
    }
    
    func setConstraints() {
        labelView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(48)
        }
        ageRestrictLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        ageRangeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(labelView.snp.bottom)
            make.height.equalTo(32)
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
