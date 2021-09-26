//
//  ViewExtension.swift
//  atom-wallet
//
//  Created by Stevhen on 26/09/21.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
