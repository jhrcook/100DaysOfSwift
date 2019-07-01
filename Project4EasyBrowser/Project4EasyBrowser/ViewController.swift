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
    
    // declare the progress view property
    var progressView: UIProgressView!
    
    // websites to choose from
    let websites = [
        "Apple": "apple.com",
        "Google": "google.com",
        "JoshDoesAThing": "joshdoesathing.com",
    ]
    
    override func loadView() {
        // make the webView the view
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // progress bar
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // bottom tool bar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let backward = UIBarButtonItem(title: "◀︎", style: .plain, target: self, action: #selector(tappedBackward))
        let forward = UIBarButtonItem(title: "▶︎", style: .plain, target: self, action: #selector(tappedForward))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [backward, forward, spacer, progressButton, spacer, share, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // KOV for progress bar
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // load Google to start with
        let url = URL(string: "https://" + websites["Google"]!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    // tapped on the "Open" button
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for websiteName in websites.keys.sorted() {
            ac.addAction(UIAlertAction(title: websiteName, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    // open a webpage when selected from action popover
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + websites[action.title!]!)!
        webView.load(URLRequest(url: url))
    }
    
    // set navbar title as the title of the website
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // tapped on the share button (share the web address)
    @objc func shareTapped() {
        if let url = webView.url {
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        } else {
            let alertPop = UIAlertController(title: "No webpage selected", message: "A website must be loaded to share.", preferredStyle: .alert)
            alertPop.addAction(UIAlertAction(title: "Done", style: .default))
            present(alertPop, animated: true, completion: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites.values {
                if host.contains(website) || host == website {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        alertBlockedLink(toUrl: url!.absoluteString)
    }
    
    func alertBlockedLink(toUrl url: String) {
        let alertController = UIAlertController(
            title: "Blocked link",
            message: "Access to \"\(url)\" is not permitted.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Done", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func tappedBackward() {
        webView.goBack()
    }
    
    @objc func tappedForward() {
        webView.goForward()
    }
}

