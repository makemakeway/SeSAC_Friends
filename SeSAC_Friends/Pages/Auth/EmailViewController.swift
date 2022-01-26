//
//  EmailViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/27.
//

import UIKit
import RxSwift

class EmailViewController: UIViewController {
    //MARK: Properties
    
    var disposeBag = DisposeBag()
    
    //MARK: UI
    let mainView = AuthView(state: .email)
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
