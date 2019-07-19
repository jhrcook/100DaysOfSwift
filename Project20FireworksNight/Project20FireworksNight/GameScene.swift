//
//  GameScene.swift
//  Project20FireworksNight
//
//  Created by Joshua on 7/18/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "current score: \(score)"
        }
    }
    
    var numberLuanches = 0
    
    
    override func didMove(to view: SKView) {
        let background =  SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: 900, y: 20)
        scoreLabel.horizontalAlignmentMode = .center
        addChild(scoreLabel)
        score = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(luanchFireworks), userInfo: nil, repeats: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        // get nodes selected
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        // loop through each node selected
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            // check that all previously selected nodes were of the same color
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            // turn this node "selected"
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    
    @objc func luanchFireworks() {
        
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // fire 5 fireworks straight up
            for xDifference in [0, -200, -100, 100, 200] {
                createFirework(xMovement: 0, x: 512 + xDifference, y: bottomEdge)
            }
        case 1:
            // fire 5 fireworks in a fan
            for xDifference in [0, -200, -100, 100, 200] {
                createFirework(xMovement: CGFloat(xDifference), x: 512 + xDifference, y: bottomEdge)
            }
        case 2:
            // fire 5 fireworks from left to right
            for yDifference in [400, 300, 200, 100, 0] {
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + yDifference)
            }
        case 3:
            // fire 5 fireworks from right to left
            for yDifference in [400, 300, 200, 100, 0] {
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + yDifference)
            }
        default:
            break
        }
        
        print("round: \(numberLuanches)")
        for child in self.children {
            print(child.name ?? "unnamed")
        }
        print("---")
        
        
        numberLuanches += 1
        if numberLuanches > 20 { gameOver() }
    }
    
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        // create Sprite container
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        // make firework
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        // set firework color
        let colors = [UIColor.cyan, UIColor.red, UIColor.green]
        firework.color = colors[Int.random(in: 0...2)]
        
        // create path
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        // make node follow path
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        // add fuse
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        // add this node to the global array of all fireworks
        fireworks.append(node)
        addChild(node)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    
    func explodeFireworks() {
        var numberExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numberExploded += 1
            }
        }
        
        score += numberExploded * numberExploded
    }
    
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            emitter.name = "explosion emitter"
            addChild(emitter)
            
            // remove emitter node after some time
            let delay = SKAction.wait(forDuration: 2)
            let removeEmitter = SKAction.run { [unowned emitter] in emitter.removeFromParent() }
            emitter.run(SKAction.sequence([delay, removeEmitter]))
        }
        firework.removeFromParent()
    }
    
    
    func gameOver() {
        gameTimer?.invalidate()
        
        let gameOverLabel = SKLabelNode()
        gameOverLabel.text = "Game Over"
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.fontSize = CGFloat(60)
        gameOverLabel.horizontalAlignmentMode = .center
        addChild(gameOverLabel)
        
    }
    
}
