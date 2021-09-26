//
//  TransactionFormView.swift
//  atom-transaction
//
//  Created by Stevhen on 26/09/21.
//

import SwiftUI
import RealmSwift

struct TransactionFormView: View {
    
    //MARK: - Variables
    @Binding var showingModal: Bool
    @State private var expandCategoryPicker: Bool
    @State private var expandWalletPicker: Bool
    @State private var expandStatusPicker: Bool
    @State private var formState: TransactionFormState
    @State private var viewState: TransactionState
    @State private var code: String = ""
    @State private var date: Date = Date()
    @State private var dateStr: String = ""
    @State private var desc: String = ""
    @State private var category: String = ""
    @State private var selectedCategory: String = ""
    @State private var wallet: String = ""
    @State private var selectedWallet: String = ""
    @State private var nominal: Int = 0
    @State private var nominalStr: String = ""
    @State private var status: TransactionState = .In
    @State private var selectedStatus: String = ""
    
    //MARK: - Main View
    init(showingModal: Binding<Bool>, viewState: TransactionState, formState: TransactionFormState, transaction: Transaction? = nil) {
        self._showingModal = showingModal
        
        self._expandCategoryPicker = State(initialValue: false)
        self._expandWalletPicker = State(initialValue: false)
        self._expandStatusPicker = State(initialValue: false)
        self._formState = State(initialValue: formState)
        self._viewState = State(initialValue: viewState)
        
        self._code = State(initialValue: generateCode())
        self._dateStr = State(initialValue: Date().toShortString)
        
        if let transaction = transaction, formState != .add {
            _code = State(initialValue: transaction.code)
            _date = State(initialValue: transaction.date)
            dateStr = date.toShortString
            _desc = State(initialValue: transaction.desc)
            _category = State(initialValue: transaction.walletDescription)
            _wallet = State(initialValue: transaction.walletDescription)
            _nominal = State(initialValue: transaction.nominal)
            nominalStr = "\(nominal)"
            _status = State(initialValue: transaction.status)
            _selectedStatus = State(initialValue: transaction.walletState.rawValue)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            
            cancelButton
            
            Spacer()
            
            Text(formState.rawValue)
                .foregroundColor(.black)
                .bold()
                .frame(width: 155)
            
            Spacer()
            
            saveButton
        }
        .padding(.top, 26)
        .padding(.bottom, 5)
        
        Form {
            
            Section {
                codeTextField
                
                dateTextField
                
                descTextField
                
                categoryPicker
                
                walletPicker
                
                nominalTextField
            }
            
        }
        .onAppear() {
            
        }
    }
}

//MARK: - View Components
extension TransactionFormView {
    private var cancelButton: some View {
        Button(action: dismissTransactionSheet) {
            Text("Cancel")
                .padding(.leading, 10)
                .frame(width: 100, alignment: .leading)
        }
    }
    
    private var saveButton: some View {
        Button(action: formState == .add ? addTransaction : saveTransaction) {
            let title = formState == .add ? "Add" : "Save"
            
            Text(title)
                .bold()
                .foregroundColor(!isFieldsComplete() ? .gray : .blue)
                .padding(.trailing, 10)
                .frame(width: 100, alignment: .trailing)
        }
    }
    
    private var codeTextField: some View {
        TextFieldView(title: "Code", status: $code)
            .disabled(true)
    }
    
    private var dateTextField: some View {
        TextFieldView(title: "Date", status: $dateStr)
    }
    
    private var descTextField: some View {
        TextFieldView(title: "Description", status: $desc)
    }
    
    private var categoryPicker: some View {
        Button(action: {
            self.expandCategoryPicker.toggle()
        }) {
            VStack(spacing: 8) {
                RowView(title: "Category", status: selectedCategory)
                
                if expandStatusPicker {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Button(action: {
                                selectedCategory = "Not Set"
                                self.expandCategoryPicker = false
                            }) {
                                Text("Cancel")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.expandCategoryPicker = false
                            }) {
                                Text("Save")
                            }
                        }
                        .foregroundColor(Color("dark-50"))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        
                        Divider().frame(height: 1)
                        
                        PickerFormView(data: getAllTransactionCases(), selection: $selectedCategory)
                            .frame(height: 200)
                    }
                }
            }
        }
    }
    
    private var walletPicker: some View {
        Button(action: {
            self.expandWalletPicker.toggle()
        }) {
            VStack(spacing: 8) {
                RowView(title: "Wallet", status: selectedWallet)
                
                if expandStatusPicker {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Button(action: {
                                selectedWallet = "Not Set"
                                self.expandWalletPicker = false
                            }) {
                                Text("Cancel")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                self.expandWalletPicker = false
                            }) {
                                Text("Save")
                            }
                        }
                        .foregroundColor(Color("dark-50"))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        
                        Divider().frame(height: 1)
                        
                        PickerFormView(data: getAllTransactionCases(), selection: $selectedWallet)
                            .frame(height: 200)
                    }
                }
            }
        }
    }
    
    private var nominalTextField: some View {
        TextFieldView(title: "Nominal", status: $nominalStr)
    }
    
    private var statusPicker: some View {
        Button(action: {
            self.expandStatusPicker.toggle()
        }) {
            VStack(spacing: 8) {
                RowView(title: "Status", status: selectedStatus)
                
                if expandStatusPicker {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Button(action: {
                                selectedStatus = "Not Set"
                                self.expandStatusPicker = false
                            }) {
                                Text("Cancel")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                status = getTransactionState(of: selectedStatus)
                                selectedStatus = status.rawValue
                                self.expandStatusPicker = false
                            }) {
                                Text("Save")
                            }
                        }
                        .foregroundColor(Color("dark-50"))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        
                        Divider().frame(height: 1)
                        
                        PickerFormView(data: getAllTransactionCases(), selection: $selectedStatus)
                            .frame(height: 200)
                    }
                }
            }
        }
    }
    
}

//MARK: - Actions
extension TransactionFormView {
    private func dismissTransactionSheet() {
        self.showingModal = false
    }
    
    private func addTransaction() {
        if isFieldsComplete() {
            self.hideKeyboard()
            saveTransaction()
            dismissTransactionSheet()
        }
    }
    
    private func editTransaction() {
        formState = .edit
    }
    
    private func saveTransaction() {
        let transaction = Transaction(code: code, desc: desc, status: viewState, date: date, nominal: nominal, walletDescription: desc, walletState: status)
        
        try! realm.write {
            realm.add(transaction)
        }
    }
    
    private func isFieldsComplete() -> Bool {
        guard nominal > 0 else { return false }
        guard desc.count >= 0 && desc.count <= 100 else { return false }
        
        return true
    }
    
    private func getAllTransactionCases() -> [String] {
        var transactionCases: [String] = []
        for transactionState in TransactionState.allCases {
            transactionCases.append(transactionState.rawValue)
        }
        return transactionCases
    }
    
    private func getTransactionState(of state: String) -> TransactionState {
        for transactionState in TransactionState.allCases {
            if transactionState.rawValue == state {
                return transactionState
            }
        }
        return .In
    }
    
    private func generateCode() -> String {
        let prefix = viewState == .In ? "WIN" : "WOUT"
        let count = realm.getLastTransactionID + 1
        return prefix + String(format: "%06d", count)
    }
}
