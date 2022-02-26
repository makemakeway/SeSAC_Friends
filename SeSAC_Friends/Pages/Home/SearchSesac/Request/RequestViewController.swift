//
//  RequestViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/14.
//

import UIKit

final class RequestViewController: UIViewController {
    
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
        self.view.backgroundColor = .systemBackground
    }
}
