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
        NavigationStack {
            Text("Yamler").font(.title2).fontWeight(.bold).padding(.bottom)
            ItemsView(base:nil, items: viewModel.wrap(), viewModel: viewModel)
        }
//        }.navigationBarBackButtonHidden(true)

    }
}


struct ItemsView: View {
    @Environment(\.undoManager) var undoManager
    
    @State var editMode: EditMode = .inactive
    @State var isEditing = false
    
    @State var showYaml = false
    @State var newItem = false
    var base: Item?
    var items: [Item]
    var viewModel: ViewModel
    var body: some View {
//        NavigationStack {
            HStack {
                Button {
                    newItem = !newItem
                } label: {
                    Image(systemName: "plus")
                }.popover(isPresented: $newItem) {
                    NewItemView(undoManager: undoManager, viewModel: viewModel, base: base) {
                        newItem = false
                    }
                }.padding(.horizontal)
                
                Button {
                    isEditing.toggle()
                    editMode = isEditing ? .active : .inactive
                } label: {
                    isEditing ? Image(systemName: "rectangle.and.pencil.and.ellipsis") :  Image(systemName: "pencil")
                }.padding(.trailing)

                Button {
                   showYaml = !showYaml
                } label: {
                    Image(systemName: "text.viewfinder")
                }.padding(.trailing)
                Spacer()
            }
            
            BodyView(items: items, viewModel: viewModel, editMode: $editMode)
           
            
            
            if showYaml {
                ItemRawView(items: try! viewModel.model.yamlStr()).background(Color.yellow)
            }
        }
        
//    }
}

struct BodyView: View {
    @State var selection: Set<String> = []
    
    var items: [Item]
    var viewModel: ViewModel
    @Binding var editMode: EditMode
    
    @Environment(\.undoManager) var undoManager
    
    var body: some View {
        List(selection: $selection) {
            ForEach(items) {
                item in
                NavigationLink {
                    // return self view when value is map.
                    // edit this when value is raw.
                    switch item.valueType {
                    case .Text, .Number, .Boolean: PrimitiveView(item: item, viewModel: viewModel).navigationTitle("Edit \(item.keyName)")
                    case .Array, .Dictionary: ItemsView(base: item, items: item.chilren, viewModel: viewModel)
                            .navigationTitle("\(item.valueType.rawValue): \(item.keyName)")
                    }
                } label: {
                    HStack {
                        /*@START_MENU_TOKEN@*/Text(item.keyName)/*@END_MENU_TOKEN@*/
                        Spacer()
                        Text(item.valueType.rawValue)
                    }
                }
                
            }.onDelete {
                sets in
                for i in sets.makeIterator() {
                    let item = items[i]
                    viewModel.deleteItem(target: item, undoManager: undoManager)
                    print("invoke delete. \(item)")
                }
            }.onMove {
                sets, index in print("invoke move. \(sets.first ?? 0) index is \(index)")
            }
            
        }.environment(\.editMode, $editMode)
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
        switch item.valueType {
        case .Text, .Number:
            Form {
                Section(header: Text("Value")) {
                    TextField("Value", text: $text)
                    .onAppear {
                        text = String(describing: item.value)

                    }
//                    .padding()
                    .onChange(of: text) {
                        c in

                        viewModel.editItem(target: item, newValue: c, undoManager: undoManager)
                    }
                }
            }
            
        case .Boolean:
            Form {
                Section(header: Text("Value")) {
                    Picker("Ture or Fasle", selection: $text) {
                        ForEach(["true", "false"], id: \.self) {
                            Text($0)
                         }
                    }
                    .onAppear {
                        text = String(describing: item.value)
                    }
//                        .padding()
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: text) {
                        tag in
                        switch tag {
                        case "true": viewModel.editItem(target: item, newValue: true, undoManager: undoManager)
                        case "false": viewModel.editItem(target: item, newValue: false, undoManager: undoManager)
                        default: break
                        }
                    }
                }
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
