//
//  Model.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import Foundation
import Yams

struct Model {

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
