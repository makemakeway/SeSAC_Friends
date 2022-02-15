//
//  SceneDelegate.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func setRootView(vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        //가입한 유저가 지우고 다시 받았을 때,
        //인증하고나면 idToken 나와서 로그인 처리가 되는데,
        //닉네임이 UserInfo에 저장이 되지 않는다.
        //이 부분에 대한 처리가 필요할 것 같다.
        
//        if UserInfo.idToken.isEmpty {
//            setRootView(vc: OnBoardingViewController())
//            print("onboarding")
//        } else if UserInfo.signUpCompleted {
//            // 홈화면
//            let tabbar = TabBarController()
//            self.window?.rootViewController = tabbar
//            self.window?.makeKeyAndVisible()
//            print("home")
//        } else {
//            setRootView(vc: NickNameViewController())
//            print("nickname")
//        }
//        let vc = InfoManageViewController()
        let vc = SearchSesacViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

