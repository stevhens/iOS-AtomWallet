//
//  Account.swift
//  atom-wallet
//
//  Created by Stevhen on 25/09/21.
//

import SwiftUI

enum WalletState: String, CaseIterable {
    case Active
    case Inactive
}

struct Wallet: Identifiable, Hashable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var reference: String
    var desc: String
    var status: WalletState
    var offset: CGFloat = 0
    
    static func getWallets() -> [Wallet] {
        return [
            Wallet(image: "A", title: "Dompet Utama", reference: "123412341", desc: "Bank X", status: .Active),
            Wallet(image: "B", title: "Dompet Tambahan", reference: "123412342", desc: "Bank Y", status: .Active),
            Wallet(image: "C", title: "Dompet Cadangan", reference: "123412343", desc: "Bank Z", status: .Active),
            Wallet(image: "C", title: "Dompet Cadangan", reference: "123412343", desc: "Bank Z", status: .Inactive),
            Wallet(image: "C", title: "Dompet Cadangan", reference: "123412343", desc: "Bank Z", status: .Inactive)
        ]
    }
}
