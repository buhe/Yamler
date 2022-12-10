//
//  Model.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import Foundation
import Yams

struct Model {
    func itemType(of desc: String) -> ItemType {
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
    func wrap() -> [Item] {
        let i = wrapMap(baseValue: rawYaml)
        print("-- \(i)")
        return i
    }
    
    func warpArray(baseValue: Any) -> [Item] {
        let array = baseValue as! [Any]
        var items: [Item] = []
        // decode to array
        for (index,value) in array.enumerated() {
            let type = itemType(of: String(reflecting: type(of: value)))
            var subItems: [Item] = []
            
            switch type {
            case .Map: subItems = wrapMap(baseValue: value)
            case .Array: subItems = warpArray(baseValue: value)
            default: break
            }
            let base = wrapItem(by: type, key: "index \(index)", value: value, chilren: subItems)
            items.append(base)
        }
        return items
    }
    
    func wrapMap(baseValue: Any) -> [Item] {
        let map = baseValue as! [String: Any]
        var items: [Item] = []
        // decode to map
        for (key,value) in map {
            let type = itemType(of: String(reflecting: type(of: value)))
            var subItems: [Item] = []
            
            switch type {
            case .Map: subItems = wrapMap(baseValue: value)
            case .Array: subItems = warpArray(baseValue: value)
            default: break
            }
            let base = wrapItem(by: type, key: key, value: value, chilren: subItems)
            items.append(base)
            
        }
        return items
    }
    
    func wrapItem(by type: ItemType,key: String,value: Any,chilren: [Item]) -> Item {
        Item(keyName: key, valueType: type, value: value, id: key, chilren: chilren)
    }
    
    
    var rawYaml: [String: Any] = ["123": ["1": 2], "abc": 12, "jjj": [111, [["2": true]]], "a": "11", "b": false]
    func yaml() throws -> Data {
        let yaml = try Yams.dump(object: rawYaml)
        return yaml.data(using: .utf8)!
    }
    
    func yamlStr() throws -> String {
        try Yams.dump(object: rawYaml)
    }
    
    init(from yaml: Data) throws {
        if let s = String(data: yaml, encoding: .utf8) {
            print("str is \(s)")
            if let value = try Yams.load(yaml: s) as? [String: Any] {
                rawYaml = value
            }
        }
    }
    
    init() {
        
    }
    
    mutating func addKey(key: String, value: Any) {
        rawYaml[key] = value
    }
    
}
