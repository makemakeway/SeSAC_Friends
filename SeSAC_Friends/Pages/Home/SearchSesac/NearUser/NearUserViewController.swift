//
//  NearUserViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/13.
//

import UIKit
import RxSwift
import RxCocoa

final class NearUserViewController: UIViewController {
    //MARK: Properties
    
    private var disposeBag = DisposeBag()
    
    //MARK: UI
    
    private let mainView = NearUserView()
    
    //MARK: Method
    func bind() {
        mainView.tableView.rx.items
            
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
