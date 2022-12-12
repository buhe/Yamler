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
    
    let undoManager: UndoManager?
    
    var viewModel: ViewModel
    var base: Item?
    let close: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                if isTop() || isNotArray() {
                    TextField("Key", text: $keyName)
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
                        close()
                    } label: {
                        Text("Save")
                    }
                    Spacer()
                    Button {
                        close()
                    } label: {
                        Text("Cancel")
                    }
                }

            }
         
        }
        
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
        case .Dictionary:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: [String:Any](), id: keyName, chilren: [],parent: [], vm: viewModel), undoManager: undoManager)
        case .Boolean:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: boolResult, id: keyName,chilren: [],parent: [], vm: viewModel),undoManager: undoManager)
        default:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: value, id: keyName,chilren: [],parent: [], vm: viewModel),undoManager: undoManager)
        }
    }
}

//struct NewItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewItemView(viewModel: ViewModel())
//    }
//}
