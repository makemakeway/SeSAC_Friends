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
    
    func changeRootViewToHome() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            let tabbar = TabBarController()
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
}
