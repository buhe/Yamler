//
//  ViewModel.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI
import UniformTypeIdentifiers

enum ShowRawState {
    case Idle
    case Loading
}
enum ItemType: String, CaseIterable {
    case Number
    case Text
    case Dictionary
    case Array
    case Boolean
}

struct Item: Identifiable {
    let keyName: String
    let valueType: ItemType
    var value: Any
    let id: String
    var chilren: [Item]
    var parent: [Item]
    var vm: ViewModel
    
    func rollback(newValue: Any) {
        if let p = parent.first {
            switch p.valueType {
            case .Dictionary:
                var map = p.value as! [String: Any]
                map[keyName] = newValue
                p.rollback(newValue: map)
            case .Array:
                var array = p.value as! [Any]
//                print("bug: \(p.keyName)   \(keyName)")
                array[Int(keyName)!] = newValue
                p.rollback(newValue: array)
            default:break
            }
        } else {
            // top level
            vm.model.rawYaml[keyName] = newValue
        }
    }
    
    func editRollback(newValue: Any) {
        if let p = parent.first {
            switch p.valueType {
            case .Dictionary:
                var map = p.value as! [String: Any]
                map[keyName] = newValue
                p.editRollback(newValue: map)
            case .Array:
                var array = p.value as! [Any]
                array[Int(keyName)!] = newValue
                p.editRollback(newValue: array)
            default:break
            }
        } else {
            // top level
            vm.model.rawYaml[keyName] = newValue
        }
    }
}


class ViewModel: ReferenceFileDocument {
    
    @Published var model: Model

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
    
    func itemType(of desc: String) -> ItemType {
        if desc.hasPrefix("Swift.Dictionary") {
            return .Dictionary
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
    func wrap() -> [Item] {
        let i = wrapMap(baseValue: model.rawYaml, parent: [])
        return i
    }
    
    func warpArray(baseValue: Any, parent: [Item]) -> [Item] {
        let array = baseValue as! [Any]
        var items: [Item] = []
        // decode to array
        for (index,value) in array.enumerated() {
            let type = itemType(of: String(reflecting: type(of: value)))
            var subItems: [Item] = []
            
            switch type {
            case .Dictionary: subItems = wrapMap(baseValue: value, parent:[Item(keyName: String(index), valueType: type, value: value, id: String(index), chilren: [], parent: parent, vm: self)])
            case .Array: subItems = warpArray(baseValue: value, parent:[Item(keyName: String(index), valueType: type, value: value, id: String(index), chilren: [], parent: parent, vm: self)])
            default: break
            }
            let base = wrapItem(by: type, key: String(index), value: value, chilren: subItems, parent: parent)
            items.append(base)
        }
        return items
    }
    
    func wrapMap(baseValue: Any, parent: [Item]) -> [Item] {
        let map = baseValue as! [String: Any]
        var items: [Item] = []
        // decode to map
        for (key,value) in map {
            let type = itemType(of: String(reflecting: type(of: value)))
            var subItems: [Item] = []
            
            switch type {
            case .Dictionary: subItems = wrapMap(baseValue: value, parent: [Item(keyName: key, valueType: type, value: value, id: key, chilren: [], parent: parent, vm: self)])
            case .Array: subItems = warpArray(baseValue: value, parent: [Item(keyName: key, valueType: type, value: value, id: key, chilren: [], parent: parent, vm: self)])
            default: break
            }
            let base = wrapItem(by: type, key: key, value: value, chilren: subItems, parent: parent)
            items.append(base)
            
        }
        return items
    }
    
    func wrapItem(by type: ItemType,key: String,value: Any,chilren: [Item],parent: [Item]) -> Item {
        Item(keyName: key, valueType: type, value: value, id: key, chilren: chilren,parent: parent, vm: self)
    }
    
    // intent
    func editItem(target: Item, newValue: Any, undoManager: UndoManager?) {
        undoablyPerform(operation: "Edit Item", with: undoManager) {
//            model.rawYaml[target.keyName] = newValue
            switch target.valueType {
            case .Text, .Number:
                target.editRollback(newValue: newValue)
            case .Boolean:
                target.editRollback(newValue: newValue)
            default: assert(false, "edit item error")
            }
        }
    }
    func insertItem(father base: Item?, use item: Item, undoManager: UndoManager?) {
        undoablyPerform(operation: "Insert Item", with: undoManager) {
            if let base { // when base != nil
                switch base.valueType {
                case ItemType.Dictionary:
                    var map = base.value as! [String: Any]
                    switch item.valueType {
                    case .Array:
                        map[item.keyName] = []
                    case .Dictionary:
                        map[item.keyName] = [:]
                    case .Number:
                        map[item.keyName] = item.value
                    case .Boolean:
                        map[item.keyName] = item.value
                    case .Text:
                        map[item.keyName] = item.value
                    }
                    print("\(base)")
                    base.rollback(newValue: map)
                case ItemType.Array:
                    var array = base.value as! [Any]
                    switch item.valueType {
                    case .Array:
                        array.append([])
                    case .Dictionary:
                        array.append([:])
                    case .Number:
                        array.append(Int(item.value as! String)!)
                    case .Boolean:
                        array.append(item.value)
                    case .Text:
                        array.append(item.value)
                    }
                    base.rollback(newValue: array)
                default: assert(false, "insert item error")
                }
            }else{
                // insert to top, top level is map
//                model.rawYaml[item.keyName] = item.value
                model.addKey(key: item.keyName, value: item.value)
            }
            
        }
        
    }
    
    func deleteItem(target item: Item, undoManager: UndoManager?) {
            
        undoablyPerform(operation: "Delete Item",with: undoManager) {
            if let father = item.parent.first {
                switch father.valueType {
                case .Array:
                    var array = father.value as! [Any]
                    array.remove(at: Int(item.keyName)!)
                    father.rollback(newValue: array)
                case .Dictionary:
                    var map = father.value as! [String: Any]
                    map.removeValue(forKey: item.keyName)
                    father.rollback(newValue: map)
                default: assert(false, "delete item error")
                }
                
            } else {
                // top level
                model.rawYaml[item.keyName] = nil
            }
        }
    }
    
    func undoablyPerform(operation: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
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
