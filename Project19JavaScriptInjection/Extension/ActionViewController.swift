//
//  ActionViewController.swift
//  Extension
//
//  Created by Joshua on 7/17/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Examples", style: .plain, target: self, action: #selector(prewrittenExamples))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    DispatchQueue.main.async { self?.title = self?.pageTitle }
                    
                    // load data if available
                    self?.loadJavaScriptCodeFor(website: self?.pageTitle ?? "")
                }
            }
        }
        
        // notifications about keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        // save website information
        saveJavaScriptCodeForWebsite()
        
        // Return any edited content to the host app.
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    // adjust scroll of text to avoid keyboard
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            let newBottom = keyboardViewEndFrame.height - view.safeAreaInsets.bottom
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: newBottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    
    struct javaScriptExample {
        let title: String
        let code: String
    }
    
    @objc func prewrittenExamples() {
        let codeExamples = [
            javaScriptExample(title: "Print page title", code: "alert(document.title)")
        ]
        
        let alertController = UIAlertController(title: "JavaScript examples", message: nil, preferredStyle: .alert)
        for codeExample in codeExamples {
            alertController.addAction(UIAlertAction(title: codeExample.title, style: .default) { [weak self] _ in
                self?.script.text = codeExample.code
            })
        }
        present(alertController, animated: true)
    }
    
    func saveJavaScriptCodeForWebsite() {
        let websiteCode = WebsiteJavaScriptCode(title: pageTitle, url: URL(string: pageURL)!, code: script.text)
        
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(websiteCode) {
            let defaults = UserDefaults.standard
            defaults.set(encodedData, forKey: websiteCode.title)
            print("saved data for \(websiteCode.title)")
        } else {
            print("could not save data for \(pageTitle)")
        }
        
    }
    
    func loadJavaScriptCodeFor(website: String) {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: website) as? Data {
            let jsonDecoder = JSONDecoder()
            if let websiteCode = try? jsonDecoder.decode(WebsiteJavaScriptCode.self, from: savedData) {
                DispatchQueue.main.async { [weak self] in self?.script.text = websiteCode.code }
                print("loaded code from \(websiteCode.title)")
            } else {
                print("no data loaded for \(website)")
                DispatchQueue.main.async { [weak self] in self?.script.text = "// enter custom JavaScript code" }
            }
        } else {
            print("no user data for \(website)")
        }
    }
}
