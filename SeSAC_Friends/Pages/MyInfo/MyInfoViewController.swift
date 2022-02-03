//
//  MyInfoViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/30.
//

import UIKit
import RxSwift
import RxCocoa

class MyInfoViewController: UIViewController {
    //MARK: Properties
    
    
    
    //MARK: UI
    let mainView = MyInfoView()
    
    
    //MARK: Method
    
    func tableViewConfig() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    //MARK: LifeCycle
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "내정보"
        tableViewConfig()
    }
}

extension MyInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.font = .title2_R16
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = UserInfo.nickname
            cell.imageView?.image = UIImage(asset: Asset.sesacFace11)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.font = .title1_M16
        case 1:
            cell.textLabel?.text = "공지사항"
            cell.imageView?.image = UIImage(asset: Asset.notice)
        case 2:
            cell.textLabel?.text = "자주 묻는 질문"
            cell.imageView?.image = UIImage(asset: Asset.faq)
        case 3:
            cell.textLabel?.text = "1:1 문의"
            cell.imageView?.image = UIImage(asset: Asset.qna)
        case 4:
            cell.textLabel?.text = "알림 설정"
            cell.imageView?.image = UIImage(asset: Asset.settingAlarm)
        case 5:
            cell.textLabel?.text = "이용 약관"
            cell.imageView?.image = UIImage(asset: Asset.permit)
        default:
            print("cell index error")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = InfoManageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("기능 없음")
        }
    }
}
