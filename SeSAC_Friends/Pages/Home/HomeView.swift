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
    
    let entireButton = UIButton().then {
        let attr = NSAttributedString(string: "전체",
                                      attributes: [NSAttributedString.Key.font: UIFont.title3_M14,
                                                   NSAttributedString.Key.foregroundColor: UIColor.defaultBlack])
        $0.setAttributedTitle(attr, for: .normal)
        $0.backgroundColor = .defaultWhite
        $0.clipsToBounds = true
    }
    
    let homeMarker = UIImageView(image: UIImage(asset: Asset.mapMarker))
    
    let manButton = UIButton().then {
        let attr = NSAttributedString(string: "남자",
                                      attributes: [NSAttributedString.Key.font: UIFont.title3_M14,
                                                   NSAttributedString.Key.foregroundColor: UIColor.defaultBlack])
        $0.setAttributedTitle(attr, for: .normal)
        $0.backgroundColor = .defaultWhite
        $0.clipsToBounds = true
    }
    
    let womanButton = UIButton().then {
        let attr = NSAttributedString(string: "여자",
                                      attributes: [NSAttributedString.Key.font: UIFont.title3_M14,
                                                   NSAttributedString.Key.foregroundColor: UIColor.defaultBlack])
        $0.setAttributedTitle(attr, for: .normal)
        $0.backgroundColor = .defaultWhite
        $0.clipsToBounds = true
    }
    
    let filterStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let stackContainerView = UIView().then {
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowOpacity = 0.6
        $0.layer.shadowRadius = 2
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
        addSubview(locationButton)
        addSubview(stackContainerView)
        addSubview(homeMarker)
        stackContainerView.addSubview(filterStack)
        
        [entireButton, manButton, womanButton].forEach {
            filterStack.addArrangedSubview($0)
        }
        
        //MARK: 버튼 이미지 색 확인
        floatingButton.setImage(UIImage(asset: Asset.antenna), for: .normal)
        floatingButton.contentMode = .scaleAspectFill
        
        self.backgroundColor = .defaultWhite
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
        
        stackContainerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(144)
            make.width.equalTo(48)
        }
        
        filterStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.top.equalTo(filterStack.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        homeMarker.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
