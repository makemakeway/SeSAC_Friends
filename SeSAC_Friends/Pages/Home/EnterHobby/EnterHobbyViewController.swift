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
    
    private var disposeBag = DisposeBag()
    
    private var dataSource = RxCollectionViewSectionedAnimatedDataSource<HobbySection>(configureCell: { (datasource, collectionView, indexPath, item) in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnterHobbyCollectionViewCell.reuseIdentifier, for: indexPath) as? EnterHobbyCollectionViewCell else { return UICollectionViewCell() }
        
        cell.button.setTitle("메뉴: \(item)", for: .normal)
        
        switch indexPath.section {
        case 0:
            cell.button.buttonState = .fill
        case 1:
            cell.button.buttonState = .outline
        default:
            cell.button.buttonState = .inactive
        }
        
        return cell
    }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) in
        print("Kind: \(kind)")
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
    
    
    private let mockSession = [
        HobbySection(header: "첫번째 섹션", items: ["김치", "삼계탕", "불고기"]),
        HobbySection(header: "두번째 섹션", items: ["짜장면", "탕수육", "마라탕", "마라샹궈"]),
        HobbySection(header: "세번째 섹션", items: ["스시", "우동", "텐동", "타코야끼"]),
    ]
    
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
        
        Observable.just(mockSession)
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
