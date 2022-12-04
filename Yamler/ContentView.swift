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
                EditButton()
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
    @State var items: [Item]
    @State var selection: Set<String> = []
    var body: some View {
        NavigationView{
            List(selection: $selection) {
                ForEach(items) {
                    item in
                    NavigationLink {
                        // edit this
                        ItemEditor(item: item)
                    } label: {
                        HStack {
                            /*@START_MENU_TOKEN@*/Text(item.keyName)/*@END_MENU_TOKEN@*/
                            Spacer()
                            Text(item.valueType)
                        }
                    }
                    
                }.onDelete {
                    index in
                }
                
            }
        }
        
    }
}

struct ItemEditor: View {
    var item: Item
    var body: some View {
        Text(item.keyName)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
