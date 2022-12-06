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
            
            ItemsView(items: viewModel.list(base: nil), viewModel: viewModel)
         
//            Text(String(data: try! viewModel.model.yaml(),encoding: .utf8)!)
        }

    }
}


struct ItemsView: View {
    @State var showYaml = false
    @State var newItem = false
    
    @State var items: [Item]
    var base: Item?
    @State var selection: Set<String> = []
    var viewModel: ViewModel
    var body: some View {
        NavigationStack{
//            if let base = base {
//                Text(base.keyName).font(.title2)
//            }
            HStack {
                Button {
                    newItem = !newItem
                } label: {
                    Image(systemName: "plus")
                }.popover(isPresented: $newItem) {
                    NewItemView(viewModel: viewModel, base: base)
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
            if showYaml {
                ItemRawView(items: try! viewModel.model.yamlStr()).background(Color.yellow)
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
