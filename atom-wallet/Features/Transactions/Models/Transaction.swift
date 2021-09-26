//
//  Transaction.swift
//  atom-wallet
//
//  Created by Stevhen on 27/09/21.
//

import SwiftUI

enum TransactionState: String, CaseIterable {
    case In
    case Out
}

struct Transaction: Identifiable, Hashable {
    var id = UUID().uuidString
    var code: String
    var desc: String
    var status: TransactionState
    var date: Date
    var nominal: Int
    
    var walletDescription: String
    var walletState: WalletState
    
    static func getTransactions() -> [Transaction] {
        return [
            Transaction(code: "WIN01", desc: "Saldo Awal", status: .In, date: Date(), nominal: 200000, walletDescription: "Incoming - Dompet Cadangan", walletState: .Active),
            Transaction(code: "WIN02", desc: "Saldo Awal", status: .In, date: Date(), nominal: 300000, walletDescription: "Incoming - Dompet Cadangan", walletState: .Active),
            Transaction(code: "WOUT01", desc: "Belanja", status: .Out, date: Date(), nominal: 400000, walletDescription: "Outgoing - Dompet Utama", walletState: .Active),
            Transaction(code: "WIN03", desc: "Saldo Dummy", status: .In, date: Date(), nominal: 500000, walletDescription: "Incoming - Dompet Cadangan", walletState: .Active),
            Transaction(code: "WIN04", desc: "Saldo Dummy", status: .In, date: Date(), nominal: 600000, walletDescription: "Incoming - Dompet Cadangan", walletState: .Active),
        ]
    }
}
