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
    let undoManager: UndoManager?
    
    var viewModel: ViewModel
    var base: Item?
    let close: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Key", text: $keyName)
                Picker("Type", selection: $type) {
                    ForEach(ItemType.allCases, id: \.self) {
                        Text($0.rawValue)
                     }
                }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: type) {
                        tag in
                        switch tag {
                        case .Array: showValueInput = false
                        case .Map: showValueInput = false
                        default: showValueInput = true
                        }
                    }
                if showValueInput {
                    TextField("Value", text: $value)
                }
                Button {
                    save()
                    close()
                } label: {
                    Text("Save")
                }
            }
         
        }
        
    }
    
    
    private func save() {
//        viewModel.model.rawYaml[keyName] = value
        switch type {
        case .Array:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: [Any](), id: keyName,chilren: []), undoManager: undoManager)
        case .Map:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: [String:Any](), id: keyName, chilren: []), undoManager: undoManager)
        default:
            viewModel.insertItem(father: base, use: Item(keyName: keyName, valueType: type, value: value, id: keyName,chilren: []),undoManager: undoManager)
        }
    }
}

//struct NewItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewItemView(viewModel: ViewModel())
//    }
//}
