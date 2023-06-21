////
////  WebViewService.swift
////  TestProject
////
////  Created by Mohammad Hijjawi on 21/06/2023.
////
//
import Foundation
import WebKit
import Combine

// MARK: - Implementation of Web View Service
class WebViewService: NSObject, WebViewServiceProtocol, WKNavigationDelegate {
    private let webView: WKWebView

    private var progressSubject = PassthroughSubject<Double, Never>()
    var estimatedProgress: AnyPublisher<Double, Never> {
        progressSubject.eraseToAnyPublisher()
    }

    private var canGoBackSubject = CurrentValueSubject<Bool, Never>(false)
    var canGoBack: AnyPublisher<Bool, Never> {
        canGoBackSubject.eraseToAnyPublisher()
    }

    private var canGoForwardSubject = CurrentValueSubject<Bool, Never>(false)
    var canGoForward: AnyPublisher<Bool, Never> {
        canGoForwardSubject.eraseToAnyPublisher()
    }

    init(webView: WKWebView) {
        self.webView = webView
        super.init()
        self.webView.navigationDelegate = self
        observeWebViewProperties()
    }

    private func observeWebViewProperties() {
        webView.publisher(for: \.estimatedProgress)
            .sink { [weak self] progress in
                self?.progressSubject.send(progress)
            }
            .store(in: &cancellables)

        webView.publisher(for: \.canGoBack)
            .sink { [weak self] canGoBack in
                self?.canGoBackSubject.send(canGoBack)
            }
            .store(in: &cancellables)

        webView.publisher(for: \.canGoForward)
            .sink { [weak self] canGoForward in
                self?.canGoForwardSubject.send(canGoForward)
            }
            .store(in: &cancellables)
    }

    func loadURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    func refresh() {
        webView.reload()
    }
}
