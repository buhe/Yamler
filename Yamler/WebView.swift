//
//  WebView.swift
//  Yamler
//
//  Created by 顾艳华 on 2022/12/14.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    var string: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let baseUrl = Bundle.main.url(forResource: "index", withExtension: "html")!.absoluteString
        print(baseUrl)
        let queryString = "?var=1232123232"
        let allUrl = URL(string: baseUrl + queryString)!
        webView.loadFileURL(allUrl, allowingReadAccessTo: allUrl)
        
        
//        let url = URL(string: "http://localhost:3000")!
//        webView.load(URLRequest(url: url))
    }
}
