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
    var body: some View {
        NavigationView {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(ItemType.allCases, id: \.self) {
                        Text($0.rawValue)
                     }
                }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: type) {
                        tag in print("Color tag: \(tag.rawValue)")
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
