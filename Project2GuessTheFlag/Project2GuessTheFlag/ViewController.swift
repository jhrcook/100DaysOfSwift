//
//  ViewController.swift
//  Project2GuessTheFlag
//
//  Created by Joshua on 6/28/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    // array of all countries
    var countries = [String]()
    // which flag (0, 1, or 2) is the correct one
    var correctAnswer = 0
    // current game score
    var score = 0
    // number of rounds
    var numberOfRoundsPlayed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // right bar item to show score when pressed
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Score",
            style: .plain,
            target: self,
            action: #selector(showScore)
        )
        
        // add all countries to the array
        countries += [
            "estonia", "france", "germany", "ireland", "italy", "monaco",
            "nigeria", "poland", "russia", "spain", "uk", "us"
        ]
        
        // add a border to the buttons
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // change the color of the borders of the buttons
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    // display flags
    func askQuestion(action: UIAlertAction! = nil) {
        // shuffle the countries array
        countries.shuffle()
        
        // set the first three flags as the button images
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        // which flag to ask for
        correctAnswer = Int.random(in: 0...2)
        
        // set title as country and current score
        title = "current score: \(score) - \(countries[correctAnswer].uppercased())"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        // increment number of rounds played
        numberOfRoundsPlayed += 1
        
        // custom message for alert if wrong answer
        var acTitle: String
        
        // handle which button is tapped
        if sender.tag == correctAnswer {
            score += 1
            title = "Correct"
            acTitle = title!
        } else {
            score -= 1
            title = "Wrong"
            acTitle = "Wrong, that is the flag of \(countries[sender.tag].uppercased())."
        }
        
        
        // alert about current score
        let ac = UIAlertController(
            title: acTitle,
            message: "Your score is \(score) of \(numberOfRoundsPlayed).",
            preferredStyle: .alert
        )
        // add an action to the alert
        ac.addAction(UIAlertAction(
            title: "Continue", style: .default, handler: askQuestion
        ))
        // present the alert
        present(ac, animated: true)
    }
    
    // show score for right bar button
    @objc func showScore() {
        let alertController = UIAlertController(
            title: "Current Score",
            message: "Your score is \(score) of \(numberOfRoundsPlayed).",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: "Done",
            style: .default)
            { (_: UIAlertAction) in print("Pressed 'Return'.") }
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
}

