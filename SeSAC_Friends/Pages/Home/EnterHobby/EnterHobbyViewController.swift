//
//  EnterHobbyViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/10.
//

import UIKit
import RxSwift
import RxCocoa


final class EnterHobbyViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    
    let mainView = EnterHobbyView()
    
    //MARK: Method
    
    func searchBarConfig() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.titleView = searchBar
    }
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfig()
    }
}
