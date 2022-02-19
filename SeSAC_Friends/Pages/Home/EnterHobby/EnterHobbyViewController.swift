//
//  EnterHobbyViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard
import SnapKit

final class EnterHobbyViewController: UIViewController {
    //MARK: Properties
    private let viewModel = EnterHobbyViewModel()
    
    private var disposeBag = DisposeBag()
    
    private lazy var dataSource = makeDataSources()
    
    private let window = UIApplication.shared.windows.first
    private lazy var extra = window!.safeAreaInsets.bottom
    
    //MARK: UI
    
    let mainView = EnterHobbyView()
    
    //MARK: Method
    
    func searchBarConfig() {
        let searchBar = UISearchBar()
        let attr = NSAttributedString(string: "띄어쓰기로 복수 입력이 가능해요",
                                      attributes: [NSAttributedString.Key.font : UIFont.title4_R14,
                                                   NSAttributedString.Key.foregroundColor : UIColor.gray6])
        let attrText = NSAttributedString(string: "",
                                          attributes: [NSAttributedString.Key.font : UIFont.title4_R14,
                                                       NSAttributedString.Key.foregroundColor : UIColor.defaultBlack])
        searchBar.searchTextField.attributedPlaceholder = attr
        searchBar.searchTextField.attributedText = attrText
        self.navigationItem.titleView = searchBar
    }
    
    func currentSearchBar() -> UISearchBar {
        guard let searchBar = navigationItem.titleView as? UISearchBar else { return UISearchBar() }
        return searchBar
    }
    
    func bind() {
        //MARK: input binding
        
        let searchBar = currentSearchBar()
        
        searchBar.rx.searchButtonClicked
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.input.searchBarText.onNext(searchBar.text ?? "")
                print(owner.extra)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing
            .asDriver()
            .drive(with: self) { owner, _ in
                UIView.animate(withDuration: 0) {
                    owner.mainView.searchSesacButton.layer.cornerRadius = 10
                    owner.mainView.searchSesacButton.snp.updateConstraints { make in
                        make.bottom.equalTo(owner.mainView.safeAreaLayoutGuide).offset(owner.extra == 0 ? -16 : 0)
                        make.leading.equalToSuperview().offset(16)
                        make.trailing.equalToSuperview().offset(-16)
                    }
                }
                owner.mainView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)


        RxKeyboard.instance.willShowVisibleHeight
            .drive(with: self) { owner, height in
                UIView.animate(withDuration: 0) {
                    owner.mainView.searchSesacButton.layer.cornerRadius = 0
                    owner.mainView.searchSesacButton.snp.updateConstraints { make in
                        make.bottom.equalTo(owner.mainView.safeAreaLayoutGuide).offset(-height + owner.extra)
                        make.leading.equalToSuperview()
                        make.trailing.equalToSuperview()
                    }
                }
                owner.mainView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)

        
        mainView.searchSesacButton.rx.tap
            .asDriver()
            .drive(viewModel.input.searchSesacButtonClicked)
            .disposed(by: disposeBag)
        
        mainView.collectionView.keyboardDismissMode = .onDrag
                
        //MARK: output binding
        
        viewModel.output.nowAround
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.activating
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, bool in
                bool == true ? owner.view.makeToastActivity(.center) : owner.view.hideToastActivity()
            }
            .disposed(by: disposeBag)

        viewModel.output.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.view.hideAllToasts()
                owner.view.makeToast(message, duration: 2.0, position: .center)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.goToNearUser
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let vc = SearchSesacViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.output.goToInfoManage
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.goToInfoManageView()
            }
            .disposed(by: disposeBag)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            let viewControllers = self.navigationController!.viewControllers
            if ((viewControllers[viewControllers.count - 2]).isKind(of: HomeViewController.self)) {
                (viewControllers[viewControllers.count - 2] as! HomeViewController).hidesBottomBarWhenPushed = false
            }
        }
    }
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfig()
        bind()
        UserInfo.printAllUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.willAppear.onNext(())
    }
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
}


// MARK: RxDataSources Configuration
extension EnterHobbyViewController {
    func makeDataSources() -> RxCollectionViewSectionedAnimatedDataSource<UserHobbySection> {
        return RxCollectionViewSectionedAnimatedDataSource<UserHobbySection>(configureCell: { (datasource, collectionView, indexPath, item) in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnterHobbyCollectionViewCell.reuseIdentifier, for: indexPath) as? EnterHobbyCollectionViewCell else { return UICollectionViewCell() }
            cell.button.setTitle("\(item.hobby)", for: .normal)
            
            switch indexPath.section {
            case 0:
                switch item.type {
                case .fromServer:
                    cell.button.buttonState = .fromServer
                default:
                    cell.button.buttonState = .fromOtherUser
                }
                cell.button.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.input.cellItemClicked.onNext((indexPath, item.hobby))
                    }
                    .disposed(by: cell.disposeBag)
            default:
                cell.button.buttonState = .fromUser
                cell.button.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.input.cellItemClicked.onNext((indexPath, item.hobby))
                    }
                    .disposed(by: cell.disposeBag)
            }
            return cell
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EnterHobbyCollectionViewSectionHeader.reuseIdentifier, for: indexPath) as? EnterHobbyCollectionViewSectionHeader else {
                    return UICollectionReusableView()
                }
                header.headerLabel.text = dataSource[indexPath.section].header
                
                return header
            default:
                assert(false, "Unexpected element kind")
            }
        })
    }
}
