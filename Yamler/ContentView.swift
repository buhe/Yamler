//
//  ContentView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                }
                Button {
                    
                } label: {
                    Image(systemName: "text.viewfinder")
                }
            }
            ItemsView(items: viewModel.list(base: nil))
//            Text(String(data: try! viewModel.model.yaml(),encoding: .utf8)!)
        }

    }
}


struct ItemsView: View {
    let items: [Item]
    var body: some View {
        List {
            ForEach(items) { item in
                /*@START_MENU_TOKEN@*/Text(item.keyName)/*@END_MENU_TOKEN@*/
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
