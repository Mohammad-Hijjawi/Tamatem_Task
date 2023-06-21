//
//  ViewController.swift
//  TestProject
//
//  Created by Mohammad Hijjawi on 19/06/2023.
//

import UIKit
import WebKit
import Combine




// MARK: - View Controller

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    private func setupButton() {
        let openButton = UIButton(type: .system)
        openButton.setTitle("Open Browser", for: .normal)
        openButton.addTarget(self, action: #selector(openBrowser), for: .touchUpInside)
        openButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openButton)

        NSLayoutConstraint.activate([
            openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func openBrowser() {
        let browserVC = BrowserViewController()
        //        let navigationController = UINavigationController(rootViewController: browserVC)
        navigationController?.pushViewController(browserVC, animated: true)
//        present(navigationController, animated: true, completion: nil)

    }
}


