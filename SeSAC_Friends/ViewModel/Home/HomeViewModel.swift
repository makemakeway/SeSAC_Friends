//
//  HomeViewModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/07.
//

import Foundation
import RxSwift

final class HomeViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    let input = Input()
    let output = Output()
    
    func transform() {
        
    }
    
    init() {
        transform()
    }
}
