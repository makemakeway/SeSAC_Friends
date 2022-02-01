//
//  OnBoardingView.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/01.
//

import UIKit
import SnapKit

class OnBoardingView: UIView, ViewRepresentable {
    
    var collectionView: UICollectionView!
    let startButton = H48Button()
    let indicator = UIPageControl().then {
        $0.frame.size = CGSize(width: 48, height: 8)
        $0.currentPageIndicatorTintColor = .defaultBlack
        $0.pageIndicatorTintColor = .gray5
        $0.numberOfPages = 3
    }
    
    func setUp() {
        collectionViewConfig()
        addSubview(startButton)
        addSubview(indicator)
        startButton.backgroundColor = .brandGreen
        startButton.setTitle("시작하기", for: .normal)
        
    }
    
    func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(indicator.snp.top).offset(-12)
        }
        
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(startButton.snp.top).offset(-12)
            
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func collectionViewConfig() {
        let spacing: CGFloat = 8
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = spacing * 2
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        collectionView.register(OnBoardingCollectionViewCell.self, forCellWithReuseIdentifier: OnBoardingCollectionViewCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)
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
