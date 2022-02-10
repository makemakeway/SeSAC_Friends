//
//  HobbySection.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/10.
//

import Foundation
import RxDataSources

struct HobbySection {
    let header: String
    var items: [String]
}

extension HobbySection: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: HobbySection, items: [String]) {
        self = original
        self.items = items
    }
}
