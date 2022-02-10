//
//  UICollectionViewCell+Extension.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/02/11.
//

import UIKit

extension UICollectionViewCell {
    static var useIdentifier: String {
        return String(describing: self)
    }
}
