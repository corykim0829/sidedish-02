//
//  SignInAuthWebViewController.swift
//  SideDishApp
//
//  Created by Cory Kim on 2020/04/29.
//  Copyright © 2020 corykim0829. All rights reserved.
//

import UIKit
import WebKit

protocol SignInAuthWebViewControllerDelegate {
    func didFinishToSignInWithGitHub()
}

class SignInAuthWebViewController: UIViewController {
    
    let webView = WKWebView()
    
    var delegate: SignInAuthWebViewControllerDelegate?
    
    private let signInSuccessStatusCode: Int = 200

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        loadGitHub()
        configureLayout()
    }
    
    private func loadGitHub() {
        guard let url = URL(string:"https://github.com/login/oauth/authorize?client_id=5d89cbaa5b442d53d545") else {return}
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func configureLayout() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension SignInAuthWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if navigationResponse.response is HTTPURLResponse {
            let response = navigationResponse.response as! HTTPURLResponse
            if response.statusCode == signInSuccessStatusCode {
                self.dismiss(animated: true, completion: {
                    self.delegate?.didFinishToSignInWithGitHub()
                })
            }
        }
        decisionHandler(.allow)
    }
}
