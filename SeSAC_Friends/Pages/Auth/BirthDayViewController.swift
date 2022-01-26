//
//  BirthDayViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/23.
//

import UIKit
import RxSwift

class BirthDayViewController: UIViewController {
    //MARK: Properties
    var disposeBag = DisposeBag()
    
    //MARK: UI
    let mainView = AuthView(state: .birthDay)
    
    
    //MARK: Method
    
    func bind() {
        mainView.datePicker.rx.controlEvent(.valueChanged)
            .subscribe { _ in
                print(self.mainView.datePicker.date)
            }
            .disposed(by: disposeBag)

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
