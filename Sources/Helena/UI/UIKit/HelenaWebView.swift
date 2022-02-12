//
//  HelenaWebView.swift
//  HelenaFramework
//
//  Created by Adrian Haubrich on 26.01.21.
//

import SwiftUI
import WebKit


public struct HelenaWebView {
    
    // URL
    var url: URL?
    
    // Init
    public init(url: String) {
        self.url = URL(string: url)
    }
    
    public init(url: URL) {
        self.url = url
    }
    
}


// MARK: - UIViewRepresentable
extension HelenaWebView: UIViewRepresentable {
    
    // Make UIView
    public func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    // Update UIView
    public func updateUIView(_ webView: WKWebView, context: Context) {
        if let request = createRequest(from: url) {
            webView.load(request)
        }
    }
    
}

// MARK: - Helper
extension HelenaWebView {
    
    private func createRequest(from url: URL?) -> URLRequest? {
        if let url = url {
            return URLRequest(url: url)
        }
        return nil
    }
    
    private func createRequest(from url: String) -> URLRequest? {
        if let url = URL(string: url) {
            return createRequest(from: url)
        }
        return nil
    }
    
}
