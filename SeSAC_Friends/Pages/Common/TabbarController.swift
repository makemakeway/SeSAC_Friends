//
//  TabbarController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/30.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .defaultWhite
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .brandGreen
        self.tabBar.unselectedItemTintColor = .gray6
        setUpTabBar()
    }
    
    
    private func setUpTabBar() {

        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem.image = UIImage(asset: Asset.property1HomeProperty2Inact) // TabBar Item 의 이미지
        homeViewController.tabBarItem.selectedImage = UIImage(asset: Asset.property1HomeProperty2Act)
        homeViewController.tabBarItem.title = "홈" // TabBar Item 의 이름
        
        let shopViewController = UINavigationController(rootViewController: ShopViewController())
        shopViewController.tabBarItem.image = UIImage(asset: Asset.property1ShopProperty2Inact)
        shopViewController.tabBarItem.selectedImage = UIImage(asset: Asset.property1ShopProperty2Act)
        shopViewController.tabBarItem.title = "새싹샵"
        
        let myInfoViewController = UINavigationController(rootViewController: MyInfoViewController())
        myInfoViewController.tabBarItem.image = UIImage(asset: Asset.property1MyProperty2Inact)
        myInfoViewController.tabBarItem.selectedImage = UIImage(asset: Asset.property1MyProperty2Act)
        myInfoViewController.tabBarItem.title = "내정보"
        
        viewControllers = [homeViewController,
                           shopViewController,
                           myInfoViewController]
    }
}
