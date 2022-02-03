//
//  InfoManageViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/02.
//

import UIKit

class InfoManageViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    let mainView = InfoManageView()
    
    
    //MARK: Method
    
    
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "정보 관리"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
