//
//  ViewModel.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI
import UniformTypeIdentifiers
enum ItemType {
    case Number
    case Text
    case Map
    case Array
    case Boolean
}
struct Item: Identifiable {
    let keyName: String
    let valueType: ItemType
    let value: Any
    let id: String
}

class ViewModel: ReferenceFileDocument {
    
    private func itemType(of desc: String) -> ItemType {
        print("desc is \(desc)")
        if desc.hasPrefix("Swift.Dictionary") {
            return .Map
        }
        if desc.hasPrefix("Swift.Array") {
            return .Array
        }
        if desc.hasPrefix("Swift.Double") {
            return .Number
        }
        if desc.hasPrefix("Swift.Int") {
            return .Number
        }
        if desc.hasPrefix("Swift.String") {
            return .Text
        }
        if desc.hasPrefix("Swift.Bool") {
            return .Boolean
        }
        return .Text
    }
    
    func list(base farther: Item?) -> [Item] {
        var items: [Item] = []
        if let farther = farther {
            // from secord row
//            switch farther.valueType {
//            case .Array:
//                // decode to array
//                for {
//                    items.append(Item(keyName: <#T##String#>, valueType: <#T##ItemType#>, value: <#T##Any#>, id: <#T##String#>))
//                }
//            case .Map:
//                // decode to map
//                for {
//                    items.append(Item(keyName: <#T##String#>, valueType: <#T##ItemType#>, value: <#T##Any#>, id: <#T##String#>))
//                }
//            default:
//                // decode as type
//                items.append(Item(keyName: <#T##String#>, valueType: <#T##ItemType#>, value: <#T##Any#>, id: <#T##String#>))
//            }
            
        } else {
            
            // from top
            for (key, value) in model.rawYaml {
                print("\(key)")
                items.append(Item(keyName: key, valueType: itemType(of: String(reflecting: type(of: value))) , value: value, id: key))
            }
        }
        return items
    }
    
    @Published var model: Model
    @Environment(\.undoManager) var undoManager
    
    static var readableContentTypes = [UTType.yaml]
    static var writeableContentTypes = [UTType.yaml]
    
    func snapshot(contentType: UTType) throws -> Data {
        try model.yaml()
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: snapshot)
    }
    
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
           model = try Model(from: data)
       } else {
           throw CocoaError(.fileReadCorruptFile)
       }
    }
    
    init() {
        model = Model()
    }
    
    // intent
    
    func insertItem(father base: Item, use item: Item) {
        undoablyPerform(operation: "Insert Item") {
            switch base.valueType {
            case ItemType.Map: break
            case ItemType.Array: break
            default: break
            }
        }
        
    }
    
    func deleteItem(father base: Item, use item: Item) {
            
        undoablyPerform(operation: "Delete Item") {
            
        }
    }
    
    func undoablyPerform(operation: String, doit: () -> Void) {
        let oldModel = model
        doit()
        undoManager?.registerUndo(withTarget: self) { myself in
            myself.undoablyPerform(operation: operation) {
                myself.model = oldModel
            }
        }
        undoManager?.setActionName(operation)
    }
}
