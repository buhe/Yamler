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
            ContentView(viewModel: file.document)
                .toolbar{
                    NavigationLink{
                        SettingsView()
                    }label: {
                        Image(systemName: "gear")
                    }
                }
                .toolbarRole(.automatic)
                .onOpenURL { url in
                    file.document.model.scheme(request: url.absoluteString)
                }
        }
    }
}
