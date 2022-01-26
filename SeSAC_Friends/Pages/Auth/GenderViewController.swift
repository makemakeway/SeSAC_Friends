//
//  GenderViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/27.
//

import UIKit
import RxSwift
import Toast

class GenderViewController: UIViewController {
    //MARK: Properties
    
    var disposeBag = DisposeBag()
    
    //MARK: UI
    let mainView = AuthView(state: .gender)
    
    
    //MARK: Method
    private func bind() {
        
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
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}
