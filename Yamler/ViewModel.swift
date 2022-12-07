//
//  ViewModel.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI
import UniformTypeIdentifiers
enum ItemType: String, CaseIterable {
    case Number
    case Text
    case Map
    case Array
    case Boolean
}
struct Item: Identifiable {
    let keyName: String
    let valueType: ItemType
    var value: Any?
    let id: String
    var num: Int
    var text: String
}


class ViewModel: ReferenceFileDocument {
    
    private func itemType(of desc: String) -> ItemType {
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
            switch farther.valueType {
            case .Array:
                let array = farther.value as! [Any]
                // decode to array
                for index in 0...array.count-1 {
                    items.append(createItem(by: itemType(of: String(reflecting: type(of: array[index]))), k: "index \(index)", v: array[index]))
                }
            case .Map:
                let map = farther.value as! [String: Any]
                // decode to map
                for (key,value) in map{
                    items.append(createItem(by: itemType(of: String(reflecting: type(of: value))), k: key, v: value))
                }
            default: break
                // decode as type
//                items.append(Item(keyName: farther.keyName, valueType: farther.valueType, value: farther.value, id: farther.keyName))
            }
            
        } else {
            
            // from top
            for (key, value) in model.rawYaml {
                print("value is \(value)")
                items.append(createItem(by: itemType(of: String(reflecting: type(of: value))), k: key, v: value))
            }
        }
        return items
    }
    
    func createItem(by type: ItemType,k key: String,v value: Any) -> Item {
        switch type {
        case .Number:
            return Item(keyName: key, valueType: type, id: key, num: value as! Int,text: "")
        case .Text:
            return Item(keyName: key, valueType: type, id: key, num: 0, text: value as! String)
        default:
            return Item(keyName: key, valueType: type, value: value, id: key, num: 0, text: "")
        }
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
