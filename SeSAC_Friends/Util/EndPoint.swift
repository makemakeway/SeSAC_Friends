//
//  EndPoint.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/24.
//

import Foundation
import RxSwift

enum EndPoint {
    case user
}

extension EndPoint {
    var url: URL {
        switch self {
        case .user:
            return .makeEndPoint("user")
        }
    }
}


extension URL {
    static let baseURL = "http://test.monocoding.com:35484/"
    static func makeEndPoint(_ endPoint: String) -> URL {
        return URL(string: baseURL + endPoint)!
    }
}
