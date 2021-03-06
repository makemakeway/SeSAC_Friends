//
//  HobbySection.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/10.
//

import Foundation
import RxDataSources

struct UserHobbySection {
    let header: String
    var items: [Hobbies]
}

extension UserHobbySection: AnimatableSectionModelType {
    typealias Item = Hobbies
    
    var identity: String {
        return header
    }
    
    init(original: UserHobbySection, items: [Hobbies]) {
        self = original
        self.items = items
    }
}

