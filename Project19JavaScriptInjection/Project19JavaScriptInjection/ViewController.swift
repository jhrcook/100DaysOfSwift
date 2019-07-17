//
//  ViewController.swift
//  Project19JavaScriptInjection
//
//  Created by Joshua on 7/17/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!

    var backgroundColorTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        changeColorsRandomly()
        backgroundColorTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeColorsRandomly), userInfo: nil, repeats: true)
    }
    
    @objc func changeColorsRandomly() {
        view.backgroundColor = makeRandomPastelColor()
        label.textColor = makeRandomDarkColor()
        label.backgroundColor = makeRandomPastelColor(withAlpha: 0.5)
    }
    
    func makeRandomPastelColor(withAlpha alpha: Float = 1.0) -> UIColor {
        return UIColor(red: CGFloat.random(in: 0.3...1.0), green: CGFloat.random(in: 0.3...1.0), blue: CGFloat.random(in: 0.3...1.0), alpha: CGFloat(alpha))
    }
    
    func makeRandomDarkColor(withAlpha alpha: Float = 1.0) -> UIColor {
        return UIColor(red: CGFloat.random(in: 0.0...0.5), green: CGFloat.random(in: 0.0...0.5), blue: CGFloat.random(in: 0.0...0.5), alpha: CGFloat(alpha))
    }
}

