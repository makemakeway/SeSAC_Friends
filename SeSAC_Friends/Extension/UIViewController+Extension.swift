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
    
    func changeRootView(viewController: UIViewController) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: viewController)
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
}
