//
//  ChatViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxKeyboard

final class ChatViewController: UIViewController {
    //MARK: Properties
    
    private var disposeBag = DisposeBag()
    
    //MARK: UI
    
    private let mainView = ChatView()
    
    //MARK: Method
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            let viewControllers = self.navigationController!.viewControllers
            if ((viewControllers[viewControllers.count - 2]).isKind(of: HomeViewController.self)) {
                (viewControllers[viewControllers.count - 2] as! HomeViewController).hidesBottomBarWhenPushed = false
            }
        }
    }
    
    private func bind() {
        RxKeyboard.instance.willShowVisibleHeight
            .drive(with: self) { owner, height in
                UIView.animate(withDuration: 0.1) {
                    owner.mainView.chatTextView.snp.updateConstraints { make in
                        make.bottom.equalTo(owner.mainView.safeAreaLayoutGuide).offset(-height)
                    }
                }
                owner.mainView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        mainView.chatTextView.textView.rx.didEndEditing
            .asDriver()
            .drive(with: self) { owner, _ in
                UIView.animate(withDuration: 0.1) {
                    owner.mainView.chatTextView.snp.updateConstraints { make in
                        make.bottom.equalTo(owner.mainView.safeAreaLayoutGuide).offset(-16)
                    }
                }
                owner.mainView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        mainView.chatTextView.textView.rx.text.orEmpty
            .bind(with: self) { owner, text in
                owner.chatTextViewTask(empty: text.isEmpty)
                owner.calculateChatTextViewHeight()
            }
            .disposed(by: disposeBag)
        
        mainView.chatTextView.sendButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                // send 버튼 눌렀을 때 일어나는 Action 정의
                owner.mainView.chatTextView.textView.text = ""
            }
            .disposed(by: disposeBag)
        
        Observable.of(["11월 23일 목요일", "1월 15일 토요일", "zzzz"])
            .bind(to: mainView.tableView.rx.items) { (tv, row, item) -> UITableViewCell in
                switch row {
                case 0:
                    guard let cell = tv.dequeueReusableCell(withIdentifier: ChatDateTableViewCell.useIdentifier, for: IndexPath(row: row, section: 0)) as? ChatDateTableViewCell else { return UITableViewCell() }
                    cell.dateLabel.text = item
                    cell.selectionStyle = .none
                    return cell
                case 1:
                    guard let cell = tv.dequeueReusableCell(withIdentifier: ChatNicknameTableViewCell.useIdentifier, for: IndexPath(row: row, section: 0)) as? ChatNicknameTableViewCell else { return UITableViewCell() }
                    cell.nicknameLabel.text = "\(item)님과 매칭되었습니다."
                    cell.selectionStyle = .none
                    return cell
                default:
                    guard let cell = tv.dequeueReusableCell(withIdentifier: ChatTableViewCell.useIdentifier, for: IndexPath(row: row, section: 0)) as? ChatTableViewCell else { return UITableViewCell() }
                    cell.chatLabel.text = "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"
                    cell.timeLabel.text = "15:02"
                    cell.selectionStyle = .none
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
    
    func calculateChatTextViewHeight() {
        let textView = mainView.chatTextView
        DispatchQueue.main.async {
            let height = textView.textView.contentSize.height
            if height <= 70 {
                textView.textView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
            }
        }
    }
    
    func chatTextViewTask(empty: Bool) {
        let textView = mainView.chatTextView
        if empty {
            textView.placeholerLabel.isHidden = false
            textView.sendButton.setImage(UIImage(asset: Asset.property1SendProperty2Inact), for: .normal)
        } else {
            textView.placeholerLabel.isHidden = true
            textView.sendButton.setImage(UIImage(asset: Asset.property1SendProperty2Act), for: .normal)
        }
    }
    
    func navBarConfig() {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .defaultBlack
        button.frame.size = CGSize(width: 24, height: 24)
        button.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                print("메뉴창")
                owner.presentMenu()
            }
            .disposed(by: disposeBag)

        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let backButton = UIButton()
        backButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                print("홈으로")
//                owner.changeRootViewToHome(homeType: .fromBackbutton)
            }
            .disposed(by: disposeBag)
        
        backButton.setImage(UIImage(asset: Asset.arrow), for: .normal)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    func presentMenu() {
        let vc = ChatMenuViewController()
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK: LifeCycle
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "채팅"
        mainView.backgroundColor = .systemBackground
        navBarConfig()
        bind()
    }
}
