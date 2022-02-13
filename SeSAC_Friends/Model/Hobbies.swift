//
//  Hobbies.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/10.
//

import Foundation
import Differentiator

struct Hobbies: Hashable {
    let hobby: String
    let type: HobbyType
    
    init(hobby: String, type: HobbyType) {
        self.hobby = hobby
        self.type = type
    }
}

extension Hobbies: IdentifiableType, Equatable {
    var identity: String {
        return UUID().uuidString
    }
}

enum HobbyType {
    case fromUser
    case fromServer
    case userSelected
}
