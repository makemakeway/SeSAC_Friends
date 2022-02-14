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
    
    let mockData: [Friends] = [
        Friends(fromQueueDB: [FromQueueDB(uid: "x4r4tjQZ8Pf9mFYUgkfmC4REcvu2",
                                          nick: "미묘한고래",
                                          lat: 37.48511640269022,
                                          long: 126.92947109241517,
                                          reputation: [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          hf: ["anything", "coding"],
                                          reviews: ["친절해요", "재밌어요"],
                                          gender: 0,
                                          type: 2,
                                          sesac: 0,
                                          background: 0)],
                fromQueueDBRequested: [FromQueueDB(uid: "x4r4tjQZ8Pf9mFYUgkfmC4REcvu2",
                                                   nick: "커피의나라",
                                                   lat: 37.48511640269022,
                                                   long: 126.92947109241517,
                                                   reputation: [4, 4, 4, 4, 4, 4, 4, 4, 4],
                                                   hf: ["anything", "coding"],
                                                   reviews: ["재밌어요", "약속을 잘지켜요"],
                                                   gender: 0,
                                                   type: 2,
                                                   sesac: 0,
                                                   background: 0)],
                fromRecommend: ["요가", "독서모임", "SeSAC", "코딩"]),
        Friends(fromQueueDB: [FromQueueDB(uid: "x4r4tjQZ8Pf9mFYUgkfmC4REcvu2",
                                          nick: "미묘한고래",
                                          lat: 37.48511640269022,
                                          long: 126.92947109241517,
                                          reputation: [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          hf: ["anything", "coding"],
                                          reviews: ["친절해요", "재밌어요"],
                                          gender: 0,
                                          type: 2,
                                          sesac: 0,
                                          background: 0)],
                fromQueueDBRequested: [FromQueueDB(uid: "x4r4tjQZ8Pf9mFYUgkfmC4REcvu2",
                                                   nick: "커피의나라",
                                                   lat: 37.48511640269022,
                                                   long: 126.92947109241517,
                                                   reputation: [4, 4, 4, 4, 4, 4, 4, 4, 4],
                                                   hf: ["anything", "coding"],
                                                   reviews: ["재밌어요", "약속을 잘지켜요"],
                                                   gender: 0,
                                                   type: 2,
                                                   sesac: 0,
                                                   background: 0)],
                fromRecommend: ["요가", "독서모임", "SeSAC", "코딩"])
    ]
    
    //MARK: UI
    
    private let mainView = NearUserView()
    
    //MARK: Method
    func bind() {
        Observable.of(mockData)
            .bind(to: mainView.tableView.rx.items(cellIdentifier: NearUserTableViewCell.useIdentifier,
                                                  cellType: NearUserTableViewCell.self)) { index, element, cell in
                let data = element.fromQueueDB[0]
                cell.cardView.nicknameLabel.text = data.nick
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
