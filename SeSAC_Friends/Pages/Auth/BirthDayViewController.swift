//
//  BirthDayViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/23.
//

import UIKit


class BirthDayViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    
    
    
    //MARK: Method
    let mainView = AuthView(state: .birthDay)
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
