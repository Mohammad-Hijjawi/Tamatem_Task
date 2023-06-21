////
////  BrowserViewController.swift
////  TestProject
////
////  Created by Mohammad Hijjawi on 21/06/2023.
////
///
import UIKit
import Combine
import WebKit

// MARK: - Browser View Controller

class BrowserViewController: UIViewController {
    private var webView: WKWebView!
    private var progressView: UIActivityIndicatorView!
    var viewModel: BrowserViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupProgressView()
        setupViewModel()
        setupNavigationBar()
        setupButtons()
        setupObservables()
        
    }

    private func setupWebView() {
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupProgressView() {
        progressView = UIActivityIndicatorView(style: .medium)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 20),
            progressView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupViewModel() {
        let webViewService = WebViewService(webView: webView)
        self.viewModel = BrowserViewModel(webViewService: webViewService)
        guard let viewModel = viewModel else { return }
         let url = URL(string: Constants.baseURL)!
            let request = URLRequest(url: url)
            self.webView.load(request)
        

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.progressView.startAnimating()
                } else {
                    self?.progressView.stopAnimating()
                }
            }
            .store(in: &cancellables)

        viewModel.$estimatedProgress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.progressView.startAnimating()
            }
            .store(in: &cancellables)

        viewModel.$urlToLoad
            .receive(on: DispatchQueue.main)
            .sink { [weak self] urlToLoad in
                if let url = urlToLoad {
                    let request = URLRequest(url: url)
                    self?.webView.load(request)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
//        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem?.isHidden = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeBrowser))
    }

    private func setupButtons() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(goForward))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))

        navigationItem.leftBarButtonItems = [backButton, forwardButton, refreshButton]
    }

    private func setupObservables() {
        viewModel?.$canGoBack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canGoBack in
                self?.navigationItem.leftBarButtonItem?.isEnabled = canGoBack
            }
            .store(in: &cancellables)

        viewModel?.$canGoForward
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canGoForward in
                self?.navigationItem.leftBarButtonItems?[1].isEnabled = canGoForward
            }
            .store(in: &cancellables)
    }

    @objc private func goBack() {
        viewModel?.goBack()
    }

    @objc private func goForward() {
        viewModel?.goForward()
    }

    @objc private func refresh() {
        viewModel?.refresh()
    }

    @objc private func closeBrowser() {
       // dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension BrowserViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel?.goBack()//.cancelLoad() // Cancel the ongoing web page load when the browser is dismissed
    }
}
