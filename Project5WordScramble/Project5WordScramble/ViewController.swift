//
//  ViewController.swift
//  Project5WordScramble
//
//  Created by Joshua on 7/1/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // declare arrays to store words
    var allWords = [String]()
    var usedWords = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add a right bar button to open submission pop-up
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        // add left bar button to start new game
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .plain, target: self, action: #selector(startGame))
        
        // prepare word lists
        if let statWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: statWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        // start first game
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    // ---- methods to handle submitted words ---- //
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        // check is every letter in word is in the title
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        let usedWordsLowercase = usedWords.map { $0.lowercased() }
        return !usedWordsLowercase.contains(word) && word != title && !word.isEmpty
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    // structures to hold information on types of errors
    struct ErrorFormat {
        let title: String
        let message: String
    }
    struct WordCheckerError {
        let targetWord: String
        let submittedWord: String
        init(targetWord: String, submittedWord: String) {
            self.targetWord = targetWord
            self.submittedWord = submittedWord
        }
        
        var notOriginal: ErrorFormat {
            let errorMessage = "\"\(submittedWord)\" has already been used."
            return(ErrorFormat(title: "Word used already", message: errorMessage))
        }
        var notReal: ErrorFormat {
            let errorMessage = "\"\(submittedWord)\" is not a real word."
            return(ErrorFormat(title: "Word not recognized", message: errorMessage))
        }
        var notPossible: ErrorFormat {
            let errorMessage = "\"\(submittedWord)\" cannot be formed from \"\(targetWord)\""
            return(ErrorFormat(title: "Word not possible", message: errorMessage))
        }
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorOptions = WordCheckerError(targetWord: title!, submittedWord: answer)
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                    alertWordError(errorOptions.notReal)
                }
            } else {
                alertWordError(errorOptions.notOriginal)
            }
        } else {
            alertWordError(errorOptions.notPossible)
        }
    }
    
    
    func alertWordError(_ errorInformation: ErrorFormat) {
        let alertController = UIAlertController(title: errorInformation.title, message: errorInformation.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

