//
//  Ex.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    static let yaml = UTType(importedAs: "dev.buhe.yaml")
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
