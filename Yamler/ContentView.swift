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
            
            ItemsView(base:nil, items: viewModel.wrap(), viewModel: viewModel)
         
//            Text(String(data: try! viewModel.model.yaml(),encoding: .utf8)!)
        }

    }
}


struct ItemsView: View {
    @Environment(\.undoManager) var undoManager
    
    @State var showYaml = false
    @State var newItem = false
    var base: Item?
    var items: [Item]
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
                    NewItemView(undoManager: undoManager, viewModel: viewModel, base: base) {
                        newItem = false
                    }
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
            
            BodyView(items: items, viewModel: viewModel)
           
            
            
            if showYaml {
                ItemRawView(items: try! viewModel.model.yamlStr()).background(Color.yellow)
            }
        }
        
    }
}

struct BodyView: View {
    @State var selection: Set<String> = []
    var items: [Item]
    var viewModel: ViewModel
    var body: some View {
        List(selection: $selection) {
            ForEach(items) {
                item in
                NavigationLink {
                    // return self view when value is map.
                    // edit this when value is raw.
                    switch item.valueType {
                    case .Text: PrimitiveView(item: item, viewModel: viewModel)
                    case .Number: PrimitiveView(item: item, viewModel: viewModel)
                    case .Boolean: PrimitiveView(item: item, viewModel: viewModel)
                    case .Array: ItemsView(base: item, items: item.chilren, viewModel: viewModel)
                    case .Map: ItemsView(base: item, items: item.chilren, viewModel: viewModel)
                    }
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

struct PrimitiveView: View {
    @Environment(\.undoManager) var undoManager
    
    @State var item: Item
    var viewModel: ViewModel
    @State var text: String = ""
//    @State var num: Int = 12
    var body: some View {
        
//        Text((viewModel.model.rawYaml["1"] as! [Any])[0] as! String)
        // change rawYaml
        // 1. access rawYaml from item
        // 2. case item.valueType cast and access rawYaml
            // bool use picker select true or false
            // other use textfeild
//        TextField("Value", value: $item.value as! Binding, format: .number)
        switch item.valueType {
        case .Text, .Number:
            TextField("", text: $text).onAppear {
                text = String(describing: item.value)
            }.onChange(of: text) {
                c in
                print(c)
                viewModel.editItem(father: nil , target: item, newValue: c, undoManager: undoManager)
                
            }
        default:
            EmptyView()
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
