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
}
