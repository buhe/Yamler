//
//  WebView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/14.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Environment(\.colorScheme) private var colorScheme
    var string: String

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let baseUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "yaml")!
//        print(baseUrl)
        var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        component?.queryItems = [URLQueryItem(name: "items", value: string), URLQueryItem(name: "theme", value: colorScheme == .dark ? "dark" : "light")]
        
        if let url = component?.url {
//            print(url)
            webview.loadFileURL(url, allowingReadAccessTo: url)
        }
        return webview
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        
        
        
        
        
//        let baseUrl = URL(string: "http://localhost:3000")!
//        var component = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
//        component?.queryItems = [URLQueryItem(name: "items", value: string)]
//        if let url = component?.url {
//            print(url)
//            webView.load(URLRequest(url: url))
//        }
        
    }
}
