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
    
    private var timerDisposable: Disposable?
    
    //MARK: UI
    let mainView = NearUserView()
    
    //MARK: Method
    
    func bind() {
        //MARK: Input Binding
        
        mainView.emptyUserView.refreshButton.rx.tap
            .asDriver()
            .drive(viewModel.input.refreshButtonClicked)
            .disposed(by: disposeBag)
        
        
        mainView.tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, indexPath in
                guard let cell = owner.mainView.tableView.cellForRow(at: indexPath) as? NearUserTableViewCell else { return }
                owner.mainView.tableView.beginUpdates()
                cell.opened.toggle()
                cell.cardView.openOrClose(opened: cell.opened)
                if cell.opened == false {
                    owner.viewModel.input.cardViewClosed.onNext(())
                }
                owner.mainView.tableView.endUpdates()
            }
            .disposed(by: disposeBag)
        
        mainView.refreshControl.rx.controlEvent(.valueChanged)
            .debug("refresh control")
            .asDriver(onErrorJustReturn: ())
            .drive(viewModel.input.refreshControlValueChanged)
            .disposed(by: disposeBag)
        
        
        //MARK: Output Binding
        
        let data = viewModel.output.nearUsers
            .share()
            .asDriver(onErrorJustReturn: [])
        
        data
            .drive(mainView.tableView.rx.items(cellIdentifier: NearUserTableViewCell.useIdentifier, cellType: NearUserTableViewCell.self)) { [weak self](index, element, cell) in
                guard let self = self else { return }
                cell.cardView.nicknameView.nicknameLabel.text = element.nick
                self.selectedSesacTitle(titles: element.reputation, view: cell.cardView.cardStackView.sesacTitleView)
                
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
        
        viewModel.output.refreshLoading
            .bind(to: mainView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.view.makeToast(message, duration: 1, position: .bottom)
            }
            .disposed(by: disposeBag)

        viewModel.output.matchedOtherUser
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let vc = ChatViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)

        viewModel.output.tooLongWaited
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    owner.changeRootViewToHome()
                }
            }
            .disposed(by: disposeBag)

        viewModel.output.goToOnboarding
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = OnBoardingViewController()
                owner.changeRootView(viewController: vc)
            }
            .disposed(by: disposeBag)


    }
    
    func timerStart() {
        timerDisposable = Observable<Int>
            .timer(.seconds(0),
                   period: .seconds(5),
                   scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.timerStarted)
    }
    
    @objc func poo() {
        print("poo")
    }
    
    func navBarConfig() {
        let button = UIButton()
        button.setTitle("찾기중단", for: .normal)
        button.titleLabel?.font = .title3_M14
        button.setTitleColor(.defaultBlack, for: .normal)
        button.addTarget(self, action: #selector(poo), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItems = [barButton]
    }
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarConfig()
        mainView.tableView.rowHeight = UITableView.automaticDimension
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.willAppear.onNext(())
        timerStart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timerDisposable?.dispose()
    }
}
