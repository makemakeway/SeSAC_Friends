//
//  CustomAlertViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/05.
//

import UIKit


class CustomAlertViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    let mainView = AlertView()
    
    
    //MARK: Method
    
    
    
    //MARK: LifeCycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
