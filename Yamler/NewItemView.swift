//
//  NewItemView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/6.
//

import SwiftUI

struct NewItemView: View {
    @State var type = ItemType.Text
    @State var keyName = ""
    @State var value = ""
    @State var showValueInput = true
    @State var showPicker = false
    @State var boolResult = false
    @FocusState private var keyFocused: Bool
    
    @State var alertMsg = ""
    @State var alertShow = false
    
    let undoManager: UndoManager?
    
    var viewModel: ViewModel
    var base: Item?
    let close: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                if isTop() || isNotArray() {
                    TextField("Key", text: $keyName).onAppear{
                        keyFocused = true
                    }.focused($keyFocused)
                }
                
                Picker("Type", selection: $type) {
                    ForEach(ItemType.allCases, id: \.self) {
                        Text($0.rawValue)
                     }
                }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: type) {
                        tag in
                        switch tag {
                        case .Array:
                            showValueInput = false
                            showPicker = false
                        case .Dictionary:
                            showValueInput = false
                            showPicker = false
                        case .Boolean:
                            showValueInput = false
                            showPicker = true
                        default:
                            showValueInput = true
                            showPicker = false
                        }
                    }
                if showValueInput {
                    TextField("Value", text: $value)
                }
                if showPicker {
                    Picker("Value", selection: $boolResult) {
                        ForEach([true, false], id: \.self) {
                            Text($0.description)
                         }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                HStack {
                    Button {
                        save()
                        
                    } label: {
                        Text("Save")
                    }
                    Spacer()
                    Button {
                        close()
                    } label: {
                        Text("Cancel")
                    }
                }.buttonStyle(.plain)

            }.alert(alertMsg, isPresented: $alertShow) {
                Button("OK", role: .cancel) { }
            }
         
        }.frame(minWidth: 500, minHeight: 220)
        
    }
    
    private func isTop() -> Bool {
        base == nil
    }
    
    private func isNotArray() -> Bool {
        base != nil && base?.valueType != .Array
    }
    
    private func save() {
//        viewModel.model.rawYaml[keyName] = value
        switch type {
        case .Array:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: [Any](), id: keyName,chilren: [],parent: [], vm: viewModel), undoManager: undoManager)
            close()
        case .Dictionary:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: [String:Any](), id: keyName, chilren: [],parent: [], vm: viewModel), undoManager: undoManager)
            close()
        case .Boolean:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: boolResult, id: keyName,chilren: [],parent: [], vm: viewModel),undoManager: undoManager)
            close()
        case .Number:
            if let num = Int(value) {
                viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: num, id: keyName,chilren: [],parent: [], vm: viewModel),undoManager: undoManager)
                close()
            } else {
                alertMsg = "Enter value is not number."
                alertShow = true
            }
            
        case .Text:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: value, id: keyName,chilren: [],parent: [], vm: viewModel),undoManager: undoManager)
            close()
        }
    }
}

//struct NewItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewItemView(viewModel: ViewModel())
//    }
//}
