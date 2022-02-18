//
//  CustomViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/19.
//

import UIKit

class CustomViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hidesBottomBarWhenPushed = false
    }
}
