//
//  ViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LogInViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    
    let mainView = AuthView()
    
    //MARK: Method
    func bind() {
        
    }
    
    //MARK: LifeCycle
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
}

