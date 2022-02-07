//
//  HomeViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    //MARK: Properties
    private var disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    //MARK: UI
    
    private let mainView = HomeView()
    
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
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
