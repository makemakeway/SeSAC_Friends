//
//  UserState.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/17.
//

import Foundation

struct UserMatchingState: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String?
}
