//
//  ViewModelType.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/19.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transForm(input: Input) -> Output
}
