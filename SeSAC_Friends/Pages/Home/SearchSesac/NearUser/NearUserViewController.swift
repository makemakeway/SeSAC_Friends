//
//  NearUserViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/13.
//

import UIKit

final class NearUserViewController: UIViewController {
    //MARK: Properties
    
    //MARK: UI
    let mainView = NearUserView()
    
    //MARK: Method
    
    //MARK: LifeCycle
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
