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


final class SearchSesacViewController: TabmanViewController {
    
    //MARK: Properties
    
    private let viewModel = NearUserViewModel()
    
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
        
        nearUserView.mainView.refreshControl.rx.controlEvent(.valueChanged)
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
    
    func bindRequestView() {
        
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
        print("poo")
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
    
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.title = "새싹 찾기"
        let bar = TMBar.ButtonBar()
        setTMBar(bar: bar)
        addBar(bar, dataSource: self, at: .top)
        self.isScrollEnabled = false
        navBarConfig()
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
