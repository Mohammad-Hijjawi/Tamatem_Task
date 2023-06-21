////
////  WebViewServiceProtocol.swift
////  TestProject
////
////  Created by Mohammad Hijjawi on 21/06/2023.
////

import Combine
import Foundation
// MARK: - Protocol for Web View Service
protocol WebViewServiceProtocol {
    func loadURL(_ url: URL)
    var estimatedProgress: AnyPublisher<Double, Never> { get }
    var canGoBack: AnyPublisher<Bool, Never> { get }
    var canGoForward: AnyPublisher<Bool, Never> { get }
    func goBack()
    func goForward()
    func refresh()
}

