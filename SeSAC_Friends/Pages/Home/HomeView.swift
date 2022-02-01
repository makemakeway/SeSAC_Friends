//
//  HomeView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/01.
//

import UIKit
import SnapKit
import NMapsMap
import Then

class HomeView: UIView, ViewRepresentable {
    
    let mapView = NMFMapView()
    let floatingButton = UIButton().then {
        $0.layer.cornerRadius = 32
        $0.backgroundColor = .defaultBlack
        $0.setImage(UIImage(asset: Asset.search), for: .normal)
        $0.tintColor = .defaultWhite
    }
    
    let filterSeg = UISegmentedControl(items: ["전체", "남자", "여자"]).then {
        $0.transform = CGAffineTransform(rotationAngle: .pi / 2)
        $0.selectedSegmentIndex = 0
        $0.selectedSegmentTintColor = .brandGreen
        $0.tintColor = .defaultWhite
        $0.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.title3_M14], for: .normal)
        $0.backgroundColor = .defaultWhite
        $0.isOpaque = false
        $0.layer.cornerRadius = 10
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.defaultWhite], for: .selected)
        $0.layer.shadowOffset = .zero
        $0.layer.shadowOpacity = 0.6
        $0.layer.shadowRadius = 2
        
        for segment in $0.subviews {
            segment.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        }
    }
    
    let locationButton = UIButton().then {
        $0.setImage(UIImage(asset: Asset.place), for: .normal)
        $0.backgroundColor = .defaultWhite
        $0.tintColor = .defaultBlack
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowOpacity = 0.6
        $0.layer.shadowRadius = 2
        
    }
    
    func setUp() {
        addSubview(mapView)
        addSubview(floatingButton)
        addSubview(filterSeg)
        addSubview(locationButton)
        
        //MARK: 버튼 이미지 색 확인
        floatingButton.setImage(UIImage(asset: Asset.antenna), for: .normal)
        floatingButton.contentMode = .scaleAspectFill
        
        
    }
    
    func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.size.equalTo(64)
        }
        
        filterSeg.snp.makeConstraints { make in
            let size = 48
            make.top.equalToSuperview().offset(size + 52)
            make.leading.equalToSuperview().offset(-size + 16)
            make.width.equalTo(size * 3)
            make.height.equalTo(size)
        }
        
        locationButton.snp.makeConstraints { make in
            let size = 48
            
            make.size.equalTo(size)
            make.top.equalTo(filterSeg.snp.bottom).offset(size + 16)
            make.leading.equalToSuperview().offset(16)
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
