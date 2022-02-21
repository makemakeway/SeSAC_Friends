//
//  ChatModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/21.
//

import Foundation

struct ChatModelElement: Codable {
    let v: Int
    let id, chat, createdAt, from: String
    let to: String

    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case chat, createdAt, from, to
    }
}

typealias ChatModel = [ChatModelElement]
