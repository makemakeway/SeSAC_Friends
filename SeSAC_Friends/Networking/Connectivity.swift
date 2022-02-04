//
//  Connectivity.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/25.
//

import Foundation
import Alamofire

final class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
