//
//  OnBoardingViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import UIKit
import SnapKit

class OnBoardingViewController: UIViewController {
    //MARK: Properties
    
    let onboardingModel = [
        OnboardingModel(centerImage: UIImage(asset: Asset.onboardingImg1)!,
                        titleImage: UIImage(asset: Asset.onboardingText1)!),
        OnboardingModel(centerImage: UIImage(asset: Asset.onboardingImg2)!,
                        titleImage: UIImage(asset: Asset.onboardingText2)!),
        OnboardingModel(centerImage: UIImage(asset: Asset.onboardingImg3)!,
                        titleImage: UIImage(asset: Asset.onboardingText3)!)
    ]
    
    
    //MARK: UI
    let mainView = OnBoardingView()
    
    
    //MARK: Method
    @objc func startButtonClicked(_ sender: UIButton) {
        let vc = RequestAuthViewController()
        self.changeRootView(viewController: vc)
    }

    
    //MARK: LifeCycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Onboarding")
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.backgroundColor = .systemBackground
        mainView.startButton.addTarget(self, action: #selector(startButtonClicked(_:)), for: .touchUpInside)
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier, for: indexPath) as? OnBoardingCollectionViewCell else { return UICollectionViewCell() }
        
        cell.centerImageView.image = onboardingModel[indexPath.row].centerImage
        cell.labelImageView.image = onboardingModel[indexPath.row].titleImage
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.width
        let currentX = scrollView.contentOffset.x
        if contentSize / currentX > 3.0 {
            mainView.indicator.currentPage = 0
        } else if contentSize / currentX > 2.0 {
            mainView.indicator.currentPage = 1
        } else if contentSize / currentX > 1 {
            mainView.indicator.currentPage = 2
        }
    }
    
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 16, height: collectionView.frame.size.height)
    }
}
