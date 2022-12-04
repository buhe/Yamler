//
//  ViewModel.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI
import UniformTypeIdentifiers

struct Item: Identifiable {
    let keyName: String
    let valueType: String
    let value: Any
    let id: String
}

class ViewModel: ReferenceFileDocument {
    

    
    func list(base farther: Item?) -> [Item] {
        var items: [Item] = []
        if let farther = farther {
            // from secord row
            
        } else {
            
            // from top
            for (key, value) in model.rawYaml {
                print("\(key)")
                items.append(Item(keyName: key, valueType: String(reflecting: type(of: value)) , value: "hey", id: key))
            }
        }
        return items
    }
    
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
    
}
