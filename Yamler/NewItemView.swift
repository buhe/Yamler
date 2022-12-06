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
            }
         
        }
        
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView()
    }
}
