//
//  NickNameViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class NickNameViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    
    let mainView = AuthView(state: .nickName)
    
    //MARK: Method
    
    
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
