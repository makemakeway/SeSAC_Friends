//
//  NearUserViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Toast

final class NearUserViewController: UIViewController {
    //MARK: Properties
    
    private var disposeBag = DisposeBag()
    
    private let viewModel = NearUserViewModel()
    
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
                                          nick: "케케케",
                                          lat: 37.48511640269022,
                                          long: 126.92947109241517,
                                          reputation: [0, 0, 0, 0, 0, 0, 0, 0, 0],
                                          hf: ["암거나 ㅋㅋ", "coding", "앙큼퐉쓰!", "미이이이이이이", "캬아아아앙아악", "구아아아아아앙"],
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
        
        //MARK: Input Binding
        
        mainView.tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, indexPath in
                guard let cell = owner.mainView.tableView.cellForRow(at: indexPath) as? NearUserTableViewCell else { return }
                owner.mainView.tableView.beginUpdates()
                cell.opened.toggle()
                cell.cardView.openOrClose(opened: cell.opened)
                owner.mainView.tableView.endUpdates()
            }
            .disposed(by: disposeBag)
        
        
        //MARK: Output Binding
        
        let data = viewModel.output.friendsValue
            .share()
            .asDriver(onErrorJustReturn: [])
        
        data
            .drive(mainView.tableView.rx.items(cellIdentifier: NearUserTableViewCell.useIdentifier, cellType: NearUserTableViewCell.self)) { [weak self](index, element, cell) in
                guard let self = self else { return }
                cell.cardView.nicknameView.nicknameLabel.text = element.nick
                
                cell.cardViewButtonClicked
                    .debug("\(index)번 카드뷰 버튼 눌림")
                    .asDriver(onErrorJustReturn: ())
                    .drive(self.viewModel.input.requestButtonClicked)
                    .disposed(by: cell.disposeBag)
                
                Observable.of(element.hf)
                    .debug("HF")
                    .bind(to: cell.cardView.cardStackView.sesacHobbyView.collectionView.rx.items(cellIdentifier: EnterHobbyCollectionViewCell.useIdentifier, cellType: EnterHobbyCollectionViewCell.self)) { index, hobby, item in
                        item.button.setTitle(hobby, for: .normal)
                        item.button.buttonState = .fromOtherUser
                        
                        let collectionView = cell.cardView.cardStackView.sesacHobbyView.collectionView
                        DispatchQueue.main.async {
                            let height = collectionView.collectionViewLayout.collectionViewContentSize.height
                            collectionView.snp.updateConstraints { make in
                                make.height.greaterThanOrEqualTo(height)
                                make.bottom.equalToSuperview()
                            }
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        data
            .drive(with: self) { owner, friends in
                if friends.isEmpty {
                    owner.mainView.emptyUserView.isHidden = false
                    owner.mainView.tableView.isHidden = true
                } else {
                    owner.mainView.emptyUserView.isHidden = true
                    owner.mainView.tableView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.activating
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, activating in
                activating == true ? owner.view.makeToastActivity(.center) : owner.view.hideToastActivity()
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
        mainView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.willAppear.onNext(())
    }
}
