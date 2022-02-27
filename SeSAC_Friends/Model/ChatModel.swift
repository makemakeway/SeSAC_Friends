//
//  ChatModel.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/21.
//

import Foundation
import RealmSwift

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

class ChatDataBaseModel: Object {
    @Persisted var text: String
    @Persisted var createdAt: String
    @Persisted var from: String
    @Persisted var to: String
    @Persisted(primaryKey: true) var id: String
    
    convenience init(text: String, createdAt: String, from: String, to: String, id: String) {
        self.init()
        self.text = text
        self.createdAt = createdAt
        self.from = from
        self.to = to
        self.id = id
    }
}

typealias ChatModel = [ChatModelElement]
