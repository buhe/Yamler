//
//  Model.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import Foundation
import Yams

struct Model {
    
    
    
    var rawYaml: [String: Any] = ["Name": "Yamler", "Description": "Yamler is the yaml viewer and editor. You can edit kubernetes config file, clash config file etc.", "Version": 3]
    func yaml() throws -> Data {
        let yaml = try Yams.dump(object: rawYaml)
        return yaml.data(using: .utf8)!
    }
    
    mutating func str2yaml(_ str: String?) {
        if let value = try? Yams.load(yaml: str!)  {
            if let v = value as? [String: Any] {
                print("yaml successed.")
                rawYaml = v
            } else {
                print("yaml failed.")
            }
            
        } else {
            print("yaml failed.")
        }
    }
    
    mutating func scheme(request: String) {
        let yaml = request.replacing("yamler://", with: "")
        print(yaml)
        let base64Decoded = Data(base64Encoded: yaml, options: Data.Base64DecodingOptions(rawValue: 0))
        let str = String(data: base64Decoded!, encoding: .utf8)
        str2yaml(str)
    }
    
    func yamlStr() throws -> String {
        try Yams.dump(object: rawYaml)
    }
    
    init(from yaml: Data) throws {
        if let s = String(data: yaml, encoding: .utf8) {
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
