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
    
    var viewModel: ViewModel
    var base: Item?
    
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
                    switch type {
                    case .Array: saveKey()
                    case .Map: saveKey()
                    default: saveKeyAndValue()
                    }
                } label: {
                    Text("Save")
                }
            }
         
        }
        
    }
    
    private func saveKey() {
        viewModel.model.rawYaml[keyName] = 0
    }
    
    private func saveKeyAndValue() {
        viewModel.model.rawYaml[keyName] = value
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(viewModel: ViewModel())
    }
}
