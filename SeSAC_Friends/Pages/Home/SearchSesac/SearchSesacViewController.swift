//
//  SearchSesacViewController.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/14.
//

import UIKit
import Tabman
import Pageboy


final class SearchSesacViewController: TabmanViewController {
    
    //MARK: Properties
    
    
    
    //MARK: UI
    let vcs = [
        NearUserViewController(),
        RequestViewController()
    ]
    
    
    //MARK: Method
    
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
    
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.title = "새싹 찾기"
        let bar = TMBar.ButtonBar()
        setTMBar(bar: bar)
        addBar(bar, dataSource: self, at: .top)
        self.isScrollEnabled = false
        
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
