//
//  ViewController.swift
//  Project15Animation
//
//  Created by Joshua on 7/14/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button: UIButton!
    var imageView: UIImageView!
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }
    
    
    
    @objc func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -250, y: -250)
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1.0
                self.imageView.backgroundColor = .clear
                
            default:
                break
            }
        }) { finished in sender.isHidden = false }
        
        
        // advance are restart counter
        currentAnimation = currentAnimation > 6 ? 0 : currentAnimation + 1
    }


}

