//
//  ChatViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/18.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    
    
    
    //MARK: Method
    
    
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            let viewControllers = self.navigationController!.viewControllers
            if ((viewControllers[viewControllers.count - 2]).isKind(of: HomeViewController.self)) {
                (viewControllers[viewControllers.count - 2] as! HomeViewController).hidesBottomBarWhenPushed = false
            }
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "채팅"
        self.view.backgroundColor = .brandWhiteGreen
    }
}
