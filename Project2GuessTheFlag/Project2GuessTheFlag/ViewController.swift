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
    // current game score
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    func askQuestion() {
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }


}

