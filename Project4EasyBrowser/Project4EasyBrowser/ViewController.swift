//
//  ViewController.swift
//  Project4EasyBrowser
//
//  Created by Joshua on 6/30/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    // declare the web view kit object
    var webView: WKWebView!
    
    // websites to choose from
    let websites = [
        "Apple": "https://www.apple.com",
        "Google": "https://www.google.com",
        "JoshDoesAThing": "https://www.joshdoesathing.com",
    ]
    
    override func loadView() {
        // make the webView the view
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // add right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTapped)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: websites["Google"]!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for websiteName in websites.keys.sorted() {
            ac.addAction(UIAlertAction(title: websiteName, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: websites[action.title!]!)!
        webView.load(URLRequest(url: url))
    }
    
    // set navbar title as the title of the website
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

}

