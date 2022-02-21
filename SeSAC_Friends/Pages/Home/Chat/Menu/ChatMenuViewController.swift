//
//  ChatMenuViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/22.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatMenuViewController: UIViewController {
    
    //MARK: Properties
    
    
    
    //MARK: UI
    private let mainView = ChatMenuView()
    
    
    //MARK: Method
    
    
    
    //MARK: LifeCycle
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
