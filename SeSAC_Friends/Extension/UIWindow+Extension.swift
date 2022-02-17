//
//  UIWindow+Extension.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/17.
//

import UIKit

extension UIWindow {
    static func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentingViewController {
                topController = presentedViewController
            }
            print("Top controller = \(topController)")
            return topController
        }
        
        return nil
    }
}
