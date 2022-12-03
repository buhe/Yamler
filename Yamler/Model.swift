//
//  Model.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import Foundation
import Yams

struct Model {
    var yamls: [String: Any] = ["key": ["1": 2]]
    func yaml() throws -> Data {
        let yaml = try Yams.dump(object: yamls)
        return yaml.data(using: .utf8)!
    }
    
    init(from yaml: Data) throws {
        if let s = String(data: yaml, encoding: .utf8) {
            print("str is \(s)")
            if let value = try Yams.load(yaml: s) as? [String: Any] {
                yamls = value
            }
        }
    }
    
    init() {
        
    }
    
}
