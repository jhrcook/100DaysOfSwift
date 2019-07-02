//
//  DetailViewController.swift
//  Project7WhitehousePetitions
//
//  Created by Joshua on 7/2/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        // replace default view with webkit view
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 100%; } </style>
        </head>
        <h3>
        \(detailItem.title)
        </h3>
        <body>
        \(detailItem.body)
        <br></br>
        <b>signature count: \(String(detailItem.signatureCount))</b>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }

}
