//
//  GameScene.swift
//  Project17SpaceRace
//
//  Created by Joshua on 7/15/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    
    var gameTimer: Timer?
    var timeTracker: Double = 0.0
    
    override func didMove(to view: SKView) {
        
        setUpView()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var locationInScene = touch.location(in: self)
        let touchedNodes = nodes(at: locationInScene)
        
        for node in touchedNodes {
            if node.name == "player" {
                if locationInScene.y < 100 {
                    locationInScene.y = 100
                } else if locationInScene.y > 668 {
                    locationInScene.y = 668
                }
                
                player.position = locationInScene
            }
        }
    }
    
    

    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        isGameOver = true
    }
    
    func setUpView() {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        player.name = "player"
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 900, y: 16)
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    @objc func createEnemy() {
        if isGameOver { return }
        
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.angularDamping = 0
        sprite.physicsBody?.linearDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
        
        if timeTracker == 0 { timeTracker = currentTime }
        
        if currentTime - timeTracker >= 10 {
            print("\(currentTime - timeTracker) seconds have passed - increasing rate!")
            timeTracker = currentTime
            gameTimer?.invalidate()
            let newInterval = Double(gameTimer!.timeInterval) / 1.3
            gameTimer = Timer.scheduledTimer(timeInterval: newInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            print("new rate: \(newInterval)")
        }
    }

    
}
