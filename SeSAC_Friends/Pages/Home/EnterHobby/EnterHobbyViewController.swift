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

final class EnterHobbyViewController: UIViewController {
    //MARK: Properties
    private let viewModel = EnterHobbyViewModel()
    
    private var disposeBag = DisposeBag()
    
    private var sections: [UserHobbySection] = []
    
    private lazy var dataSource = makeDataSources()
    
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
    
    func bind() {
        //MARK: input binding
        mainView.searchSesacButton.rx.tap
            .asDriver()
            .drive(viewModel.input.searchSesacButtonClicked)
            .disposed(by: disposeBag)
                
        //MARK: output binding
        let nowAround = viewModel.output.nowAround
            .share()
        
        nowAround
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        nowAround
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, sections in
                owner.sections = sections
            }
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.willAppear.onNext(())
        
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
