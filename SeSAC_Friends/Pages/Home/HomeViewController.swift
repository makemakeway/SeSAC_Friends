//
//  HomeViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/29.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    
    let mainView = HomeView()
    
    //MARK: Method
    
    
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
