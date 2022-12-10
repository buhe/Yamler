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
    var value: Any
    let id: String
    var chilren: [Item]
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
    
    // intent
    func editItem(father base: Item?, target: Item, newValue: Any, undoManager: UndoManager?) {
        undoablyPerform(operation: "Edit Item", with: undoManager) {
            model.rawYaml[target.keyName] = newValue
        }
    }
    func insertItem(father base: Item?, use item: Item, undoManager: UndoManager?) {
        undoablyPerform(operation: "Insert Item", with: undoManager) {
            if let base { // when base != nil
                switch base.valueType {
                case ItemType.Map: break
                case ItemType.Array: break
                default: break
                }
            }else{
                // insert to top, top level is map
//                model.rawYaml[item.keyName] = item.value
                model.addKey(key: item.keyName, value: item.value)
            }
            
        }
        
    }
    
    func deleteItem(father base: Item, use item: Item, undoManager: UndoManager?) {
            
        undoablyPerform(operation: "Delete Item",with: undoManager) {
            
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
