//
//  UITableViewCell+Extension.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/14.
//

import UIKit

extension UITableViewCell {
    static var useIdentifier: String {
        return String(describing: self)
    }
}
