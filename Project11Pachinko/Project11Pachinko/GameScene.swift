//
//  GameScene.swift
//  Project11Pachinko
//
//  Created by Joshua on 7/6/19.
//  Copyright © 2019 JHC Dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // ball image file names
    let ballImages = [
        "ballBlue", "ballYellow", "ballPurple", "ballGrey",
        "ballRed", "ballCyan", "ballGreen"
    ]
    
    // ball count
    var ballCountLabel: SKLabelNode!
    var ballCount = 5 {
        didSet {
            ballCountLabel.text = "\(ballCount) balls"
        }
    }
    
    // for tracking the score
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // for tracking in editing mode or not
    var editLabel: SKLabelNode!
    var editingMode = false {
        didSet {
            editLabel.text = editingMode ? "Done" : "Edit"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        physicsWorld.contactDelegate = self
        
        for x in [0, 256, 512, 768, 1024] {
            makeBouncer(at: CGPoint(x: x, y: 0))
        }
        var isGoodSwitch = true
        for x in [128, 384, 640, 896] {
            makeSlot(at: CGPoint(x: x, y: 0), isGood: isGoodSwitch)
            isGoodSwitch = !isGoodSwitch
        }
        
        // style the score label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        // style the ball count label
        ballCountLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballCountLabel.text = "5 balls"
        ballCountLabel.horizontalAlignmentMode = .right
        ballCountLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballCountLabel)
        
        // style edit label
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            // list of all nodes at the location
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                // if pressed editing label
                editingMode.toggle()
            } else {
                if editingMode {
                    // add a box
                    createABox(at: location)
                } else if location.y >= 700 {
                    // add a ball
                    ballCount -= 1
                    let ball = SKSpriteNode(imageNamed: ballImages.randomElement()!)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody?.restitution = 0.4
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at postion: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotBase.position = postion
        slotGlow.position = postion
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    // create a box somewhere in the game
    func createABox(at location: CGPoint) {
        let size = CGSize(width: Int.random(in: 70...200), height: 16)
        let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        let box = SKSpriteNode(color: color, size: size)
        box.zRotation = CGFloat.random(in: 0...CGFloat.pi)
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "obstacle"
        addChild(box)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball)
            score += 1
            ballCount += 1
        } else if object.name == "bad" {
            destroy(ball)
            score -= 1
        } else if object.name == "obstacle" {
            object.removeFromParent()
        }
    }
    
    func destroy(_ ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
}
