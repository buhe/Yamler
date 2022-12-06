//
//  ContentView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State var showYaml = false
    @State var newItem = false
    var body: some View {
        VStack {
            HStack {
                Button {
                    newItem = !newItem
                } label: {
                    Image(systemName: "plus")
                }.popover(isPresented: $newItem) {
                    NewItemView()
                }
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                }
//                EditButton()
                Button {
                   showYaml = !showYaml
                } label: {
                    Image(systemName: "text.viewfinder")
                }
            }
            ItemsView(items: viewModel.list(base: nil), viewModel: viewModel)
            if showYaml {
                ItemRawView(items: try! viewModel.model.yamlStr()).background(Color.yellow)
            }
//            Text(String(data: try! viewModel.model.yaml(),encoding: .utf8)!)
        }

    }
}


struct ItemsView: View {
    @State var items: [Item]
    var base: Item?
    @State var selection: Set<String> = []
    var viewModel: ViewModel
    var body: some View {
        NavigationView{
//            if let base = base {
//                Text(base.keyName).font(.title2)
//            }
            List(selection: $selection) {
                ForEach(items) {
                    item in
                    NavigationLink {
                        // return self view when value is map.
                        // edit this when value is raw.
                        ItemsView(items: viewModel.list(base: item), base: item, viewModel: viewModel)
                    } label: {
                        HStack {
                            /*@START_MENU_TOKEN@*/Text(item.keyName)/*@END_MENU_TOKEN@*/
                            Spacer()
                            Text(item.valueType.rawValue)
                        }
                    }
                    
                }.onDelete {
                    index in
                }
                
            }
        }
        
    }
}


struct ItemRawView: View {
    var items: String
    var body: some View {
        Text(items).frame(alignment: .leading).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
