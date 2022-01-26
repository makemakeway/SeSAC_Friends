//
//  DateManager.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/27.
//

import Foundation
import Then

final class DateManager {
    static let shared = DateManager()
    
    private init() {
        
    }
    
    let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd'T'hh:MM:ss.SSS'Z'"
        $0.locale = Locale(identifier: Locale.current.identifier)
        $0.timeZone = TimeZone(identifier: TimeZone.current.identifier)
    }
    
    func dateToString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(dateFormat: String) -> Date {
        return dateFormatter.date(from: dateFormat)!
    }
}
