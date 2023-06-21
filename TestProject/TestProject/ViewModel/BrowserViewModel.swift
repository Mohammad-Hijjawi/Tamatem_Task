////
////  BrowserViewModel.swift
////  TestProject
////
////  Created by Mohammad Hijjawi on 21/06/2023.
////
//
import Foundation
import Combine

// MARK: - View Model
class BrowserViewModel: ObservableObject {
    private let webViewService: WebViewServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var isLoading = false
    @Published var estimatedProgress = 0.0
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var urlToLoad: URL?

    init(webViewService: WebViewServiceProtocol) {
        self.webViewService = webViewService
        observeWebViewServiceProperties()
    }

    private func observeWebViewServiceProperties() {
        webViewService.estimatedProgress
            .receive(on: DispatchQueue.main)
            .assign(to: \.estimatedProgress, on: self)
            .store(in: &cancellables)

        webViewService.canGoBack
            .receive(on: DispatchQueue.main)
            .assign(to: \.canGoBack, on: self)
            .store(in: &cancellables)

        webViewService.canGoForward
            .receive(on: DispatchQueue.main)
            .assign(to: \.canGoForward, on: self)
            .store(in: &cancellables)
        $urlToLoad
            .compactMap { $0 }
            .sink { [weak self] url in
                self?.isLoading = true
                self?.webViewService.loadURL(url)
            }
            .store(in: &cancellables)
    }

    func loadURL(_ url: URL) {
        isLoading = true
        urlToLoad = url
    }

    func goBack() {
        webViewService.goBack()
    }

    func goForward() {
        webViewService.goForward()
    }

    func refresh() {
        webViewService.refresh()
    }
}

