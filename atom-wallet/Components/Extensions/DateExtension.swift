//
//  DateExtension.swift
//  atom-wallet
//
//  Created by Stevhen on 27/09/21.
//

import SwiftUI

extension Date {
    var toShortString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
