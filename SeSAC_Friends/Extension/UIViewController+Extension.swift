//
//  UIViewController+Extension.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/29.
//

import Foundation
import UIKit

extension UIViewController {
    func printUserInfo() {
        print("Gender: \(UserInfo.gender)")
        print("phoneNumber: \(UserInfo.phoneNumber)")
        print("birthday: \(UserInfo.birthday)")
        print("email: \(UserInfo.email)")
        print("nickname: \(UserInfo.nickname)")
    }
    
    func changeRootViewToHome(homeType: HomeType = .defaults) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            let tabbar = TabBarController()
            
            if homeType == .fromBackbutton {
                guard let nav = tabbar.viewControllers?[0] as? UINavigationController else { return }
                guard let home = nav.viewControllers[0] as? HomeViewController else { return }
                home.homeType = .fromBackbutton
            }
            
            windowScene.windows.first?.rootViewController = tabbar
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
    
    func changeRootView(viewController: UIViewController) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            let nav = UINavigationController(rootViewController: viewController)
            windowScene.windows.first?.rootViewController = nav
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
    
    func goToInfoManageView() {
        tabBarController?.selectedIndex = 2
        guard let nav = tabBarController?.selectedViewController as? UINavigationController else { return }
        let vc = InfoManageViewController()
        vc.needSelectGender = true
        nav.pushViewController(vc, animated: true)
    }
    
    func setSesacAndBackgroundImage(background: Int, sesac: Int, view: CardImageView) {
        switch background {
        case 0:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground1)
        case 1:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground2)
        case 2:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground3)
        case 3:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground4)
        case 4:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground5)
        case 5:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground6)
        case 6:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground7)
        case 7:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground8)
        default:
            view.backgroundImage.image = UIImage(asset: Asset.sesacBackground1)
        }
        
        switch sesac {
        case 0:
            view.sesacImage.image = UIImage(asset: Asset.sesacFace1)
        case 1:
            view.sesacImage.image = UIImage(asset: Asset.sesacFace2)
        case 2:
            view.sesacImage.image = UIImage(asset: Asset.sesacFace3)
        case 3:
            view.sesacImage.image = UIImage(asset: Asset.sesacFace4)
        case 4:
            view.sesacImage.image = UIImage(asset: Asset.sesacFace5)
        default:
            view.sesacImage.image = UIImage(asset: Asset.sesacFace1)
        }
    }
    
    func selectedSesacTitle(titles: [Int], view: SesacTitleView) {
        let view = view.titleStackView
        for (index, title) in titles.enumerated() {
            if title != 0 {
                switch index {
                case 0:
                    view.goodMannerButton.buttonState = .fill
                case 1:
                    view.exactTimeButton.buttonState = .fill
                case 2:
                    view.fastResponseButton.buttonState = .fill
                case 3:
                    view.kindnessButton.buttonState = .fill
                case 4:
                    view.greatJobButton.buttonState = .fill
                case 5:
                    view.goodTimeButton.buttonState = .fill
                default:
                    print("아직 추가 안된 케이스")
                }
            }
        }
    }
}
