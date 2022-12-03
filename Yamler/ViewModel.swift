//
//  ViewModel.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI
import UniformTypeIdentifiers

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
    
    
}
