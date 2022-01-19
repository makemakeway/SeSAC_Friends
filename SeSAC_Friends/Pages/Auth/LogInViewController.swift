//
//  LogInViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/20.
//

import UIKit
import RxCocoa
import RxSwift

class LogInViewController: UIViewController {
    //MARK: Properties
    
    var disposeBag = DisposeBag()
    
    //MARK: UI
    
    let mainView = AuthView()
    
    //MARK: Method
    
    
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.titleLabel.setTextWithLineHeight(text: "인증번호가 문자로 전송되었어요", lineHeight: 32, font: .display1_R20)
        mainView.calloutLabel.text = "(최대 소모 20초)"
        mainView.authRequestButton.setTitle("인증하고 시작하기", for: .normal)
    }
}
