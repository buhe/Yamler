//
//  YamlerApp.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/1.
//

import SwiftUI

@main
struct YamlerApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { ViewModel() }) { file in
            ContentView(viewModel: file.document).toolbar(.hidden).toolbarRole(.automatic)
        }
    }
}
