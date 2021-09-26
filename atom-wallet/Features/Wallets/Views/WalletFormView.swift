//
//  WalletFormView.swift
//  atom-wallet
//
//  Created by Stevhen on 26/09/21.
//

import SwiftUI

struct WalletFormView: View {
    
    //MARK: - Variables
    @Binding var showingModal: Bool
    @State private var expandStatusPicker: Bool = false
    @State private var formState: WalletFormState
    @State private var name: String = ""
    @State private var reference: String = ""
    @State private var desc: String = ""
    @State private var status: WalletState = .Active
    @State private var selectedStatus: String = ""
    
    //MARK: - Main View
    init(showingModal: Binding<Bool>, state: WalletFormState, wallet: Wallet? = nil) {
        self._showingModal = showingModal
        self.expandStatusPicker = false
        self.formState = state
        
        if let wallet = wallet, state != .add {
            _name = State(initialValue: wallet.title)
            _reference = State(initialValue: wallet.reference)
            _desc = State(initialValue: wallet.desc)
            _status = State(initialValue: wallet.status)
            _selectedStatus = State(initialValue: wallet.status.rawValue)
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
                nameTextField
                
                referenceTextField
                
                descTextField
                
                statusPicker
            }
            .disabled(formState == .view)
            
        }
        .onAppear() {
            
        }
    }
}

//MARK: - View Components
extension WalletFormView {
    private var cancelButton: some View {
        Button(action: dismissWalletSheet) {
            Text("Cancel")
                .padding(.leading, 10)
                .frame(width: 100, alignment: .leading)
        }
    }
    
    private var saveButton: some View {
        Button(action: formState == .add ? addWallet : (formState == .view ? editWallet : saveWallet)) {
            let title = formState == .add ? "Add" : (formState == .view ? "Edit" : "Save")
            
            Text(title)
                .fontWeight(formState != .view ? .bold : .regular)
                .foregroundColor(!isFieldsComplete() && formState != .view ? .gray : .blue)
                .padding(.trailing, 10)
                .frame(width: 100, alignment: .trailing)
        }
    }
    
    private var editWalletButton: some View {
        Button(action: addWallet) {
            Text("Edit")
                .padding(.trailing, 10)
                .frame(width: 100, alignment: .trailing)
        }
    }
    
    private var nameTextField: some View {
        TextFieldView(title: "Name", status: $name)
    }
    
    private var referenceTextField: some View {
        TextFieldView(title: "Reference", status: $reference)
    }
    
    private var descTextField: some View {
        TextFieldView(title: "Description", status: $desc)
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
                                status = getWalletState(of: selectedStatus)
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
                        
                        PickerFormView(data: getAllWalletCases(), selection: $selectedStatus)
                            .frame(height: 200)
                    }
                }
            }
        }

    }
}

//MARK: - Actions
extension WalletFormView {
    private func dismissWalletSheet() {
        self.showingModal = false
    }
    
    private func addWallet() {
        if isFieldsComplete() {
            self.hideKeyboard()
            saveWallet()
            dismissWalletSheet()
        }
    }
    
    private func editWallet() {
        formState = .edit
    }
    
    private func saveWallet() {
//        let wallet = Wallet(image: name[0], title: name, reference: reference, desc: desc, status: status)
//        
//        try! realm.write {
//            realm.add(wallet)
//        }
    }
    
    private func isFieldsComplete() -> Bool {
        guard !name.isEmpty && name.count >= 5 else { return false }
        guard reference.count >= 0 && reference.count <= 100 else { return false }
        guard !desc.isEmpty else { return false }
        
        return true
    }
    
    private func getAllWalletCases() -> [String] {
        var walletCases: [String] = []
        for walletState in WalletState.allCases {
            walletCases.append(walletState.rawValue)
        }
        return walletCases
    }
    
    private func getWalletState(of state: String) -> WalletState {
        for walletState in WalletState.allCases {
            if walletState.rawValue == state {
                return walletState
            }
        }
        return .Active
    }
}
