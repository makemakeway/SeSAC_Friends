//
//  SearchSesacViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/14.
//

import UIKit
import Tabman
import Pageboy
import RxSwift
import RxCocoa
import Toast

final class SearchSesacViewController: TabmanViewController {
    
    //MARK: Properties
    
    private let viewModel = NearUserViewModel()
    private let disposeBag = DisposeBag()
    private var timerDisposable: Disposable?
    
    //MARK: UI
    let vcs = [
        NearUserViewController(),
        RequestViewController()
    ]
    
    
    //MARK: Method
    
    func bindNearUserView() {
        let nearUserView = vcs[0] as! NearUserViewController
        nearUserView.mainView.emptyUserView.refreshButton.rx.tap
            .asDriver()
            .drive(viewModel.input.refreshButtonClicked)
            .disposed(by: disposeBag)
        
        nearUserView.mainView.tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, indexPath in
                guard let cell = nearUserView.mainView.tableView.cellForRow(at: indexPath) as? NearUserTableViewCell else { return }
                nearUserView.mainView.tableView.beginUpdates()
                cell.opened.toggle()
                cell.cardView.openOrClose(opened: cell.opened)
                if cell.opened == false {
                    owner.viewModel.input.cardViewClosed.onNext(())
                }
                nearUserView.mainView.tableView.endUpdates()
            }
            .disposed(by: disposeBag)
        
        nearUserView.mainView.refreshControl.rx.controlEvent(.valueChanged)
            .debug("refresh control")
            .asDriver(onErrorJustReturn: ())
            .drive(viewModel.input.refreshControlValueChanged)
            .disposed(by: disposeBag)
        
        
        //MARK: Output Binding
        
        viewModel.output.activating
            .debug("Activating")
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, activating in
                let currentVC = owner.vcs[0] as! NearUserViewController
                activating == true ? currentVC.view.makeToastActivity(.center) : currentVC.view.hideToastActivity()
            }
            .disposed(by: disposeBag)
        
        let data = viewModel.output.nearUsers
            .share()
            .asDriver(onErrorJustReturn: [])
        
        data
            .drive(nearUserView.mainView.tableView.rx.items(cellIdentifier: NearUserTableViewCell.useIdentifier, cellType: NearUserTableViewCell.self)) { [weak self](index, element, cell) in
                guard let self = self else { return }
                cell.cardView.nicknameView.nicknameLabel.text = element.nick
                self.selectedSesacTitle(titles: element.reputation, view: cell.cardView.cardStackView.sesacTitleView)
                cell.cardViewButton.cardType = .require
                
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
                    nearUserView.mainView.emptyUserView.isHidden = false
                    nearUserView.mainView.tableView.isHidden = true
                } else {
                    nearUserView.mainView.emptyUserView.isHidden = true
                    nearUserView.mainView.tableView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.refreshLoading
            .bind(to: nearUserView.mainView.refreshControl.rx.isRefreshing)
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
    
    func bindRequestView() {
        let requestView = vcs[1] as! RequestViewController
        requestView.mainView.emptyUserView.refreshButton.rx.tap
            .asDriver()
            .drive(viewModel.input.refreshButtonClicked)
            .disposed(by: disposeBag)
        
        requestView.mainView.tableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, indexPath in
                guard let cell = requestView.mainView.tableView.cellForRow(at: indexPath) as? NearUserTableViewCell else { return }
                requestView.mainView.tableView.beginUpdates()
                cell.opened.toggle()
                cell.cardView.openOrClose(opened: cell.opened)
                if cell.opened == false {
                    owner.viewModel.input.cardViewClosed.onNext(())
                }
                requestView.mainView.tableView.endUpdates()
            }
            .disposed(by: disposeBag)
        
        requestView.mainView.refreshControl.rx.controlEvent(.valueChanged)
            .debug("refresh control")
            .asDriver(onErrorJustReturn: ())
            .drive(viewModel.input.refreshControlValueChanged)
            .disposed(by: disposeBag)
        
        
        //MARK: Output Binding
        
        let data = viewModel.output.nearUsers
            .share()
            .asDriver(onErrorJustReturn: [])
        
        data
            .drive(requestView.mainView.tableView.rx.items(cellIdentifier: NearUserTableViewCell.useIdentifier, cellType: NearUserTableViewCell.self)) { [weak self](index, element, cell) in
                guard let self = self else { return }
                cell.cardView.nicknameView.nicknameLabel.text = element.nick
                self.selectedSesacTitle(titles: element.reputation, view: cell.cardView.cardStackView.sesacTitleView)
                cell.cardViewButton.cardType = .required
                cell.cardViewButton.setTitle("수락하기", for: .normal)
                
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
                    requestView.mainView.emptyUserView.isHidden = false
                    requestView.mainView.tableView.isHidden = true
                } else {
                    requestView.mainView.emptyUserView.isHidden = true
                    requestView.mainView.tableView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.activating
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, activating in
                let currentVC = owner.vcs[1] as! RequestViewController
                activating == true ? currentVC.view.makeToastActivity(.center) : currentVC.view.hideToastActivity()
            }
            .disposed(by: disposeBag)
        
        viewModel.output.refreshLoading
            .bind(to: requestView.mainView.refreshControl.rx.isRefreshing)
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

    
    func setTMBar(bar: TMBar.ButtonBar) {
        bar.buttons.customize { button in
            button.tintColor = .gray6
            button.selectedTintColor = .brandGreen
            button.font = .title3_M14
        }
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .snap
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .brandGreen
        bar.indicator.overscrollBehavior = .compress
        
        bar.backgroundView.style = .flat(color: .defaultWhite)
    }
    
    @objc func poo() {
        timerDisposable?.dispose()
    }
    
    func navBarConfig() {
        let button = UIButton()
        button.setTitle("찾기중단", for: .normal)
        button.titleLabel?.font = .title3_M14
        button.setTitleColor(.defaultBlack, for: .normal)
        button.addTarget(self, action: #selector(poo), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func timerStart() {
        timerDisposable = Observable<Int>
            .timer(.seconds(0),
                   period: .seconds(5),
                   scheduler: MainScheduler.instance)
            .bind(to: viewModel.input.timerStarted)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        viewModel.input.willAppear.onNext(())
    }
    
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindNearUserView()
        bindRequestView()
        self.dataSource = self
        self.title = "새싹 찾기"
        let bar = TMBar.ButtonBar()
        setTMBar(bar: bar)
        addBar(bar, dataSource: self, at: .top)
        self.isScrollEnabled = false
        navBarConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerStart()
    }
}

extension SearchSesacViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "주변 새싹", badgeValue: nil)
        default:
            return TMBarItem(title: "받은 요청", badgeValue: nil)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vcs.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
    
}
