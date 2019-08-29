//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Kevin Kong on 8/20/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    
    var scoreLabel = SKLabelNode()
    
    var gameOverLabel = SKLabelNode()
    
    var bird = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var pipe1 = SKSpriteNode()
    
    var pipe2 = SKSpriteNode()
    
    enum ColliderType: UInt32 {
    
        case Bird = 1
        case Object = 2
        case Gap = 4
    
    }
    
    var gameOver = false
    
    var movingObjects = SKSpriteNode()
    
    var labelContainer = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        
        makeBg()
        
        
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
    
        
        // Animate the bird
        let birdTexture1 = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture1)
        
        // Position the bird then run animation
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        
        
        // Define bird's body and give it gravity
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture1.size().height/2)
        bird.physicsBody!.dynamic = true
        
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        // Add the bird to the view (self)
        self.addChild(bird)
        
        
        // Define the ground as another body, but don't give it gravity
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody!.dynamic = false
        
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        
        /* Define the sky
        var sky = SKNode()
        sky.position = CGPointMake(0, self.frame.size.height)
        sky.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        sky.physicsBody!.dynamic = false
        
        sky.physicsBody!.categoryBitMask = ColliderType.Sky.rawValue
        sky.physicsBody!.contactTestBitMask = ColliderType.Sky.rawValue
        sky.physicsBody!.collisionBitMask = ColliderType.Sky.rawValue
        
        self.addChild(sky)
*/
        
        
        
        // Define the pipes
        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "makePipes", userInfo: nil, repeats: true)
    
    }
    
    func makeBg() {
    
        // Background
        let bgTexture = SKTexture(imageNamed: "bg.png")
        let bgAnimation = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let bgMoveForever = SKAction.repeatActionForever(SKAction.sequence([bgAnimation, replacebg]))
        
        for var i: CGFloat = 0; i < 3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width / 2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.zPosition = -5
            bg.runAction(bgMoveForever)
            
            movingObjects.addChild(bg)
            
        }

    
    }
    
    func makePipes() {
        let pipeTexture1 = SKTexture(imageNamed: "pipe1.png")
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        
        let pipeMovement = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
        let movePipes = SKAction.repeatActionForever(pipeMovement)
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        pipe1 = SKSpriteNode(texture: pipeTexture1)
        pipe2 = SKSpriteNode(texture: pipeTexture2)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture1.size())
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture2.size())
        
        pipe1.physicsBody!.dynamic = false
        pipe2.physicsBody!.dynamic = false
        
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        
        let gapHeight = bird.size.height * 4
        let movementAmount = CGFloat(arc4random()) % self.frame.size.height / 2
        let pipeOffset = movementAmount - CGFloat(self.frame.size.height / 4)
        
        pipe1.position = CGPoint(x: self.frame.size.width * 1.5, y: CGRectGetMidY(self.frame) + pipeTexture1.size().height/2 + gapHeight / 2 + pipeOffset)
        pipe2.position = CGPoint(x: self.frame.size.width * 1.5, y: CGRectGetMidY(self.frame) - pipeTexture2.size().height/2 - gapHeight / 2 + pipeOffset)
        
        pipe1.runAction(moveAndRemovePipes)
        pipe2.runAction(moveAndRemovePipes)
        
        movingObjects.addChild(pipe1)
        movingObjects.addChild(pipe2)
        
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.size.width * 1.5, y: CGRectGetMidY(self.frame) + pipeOffset)
        gap.runAction(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight))
        gap.physicsBody!.dynamic = false
        
        
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        movingObjects.addChild(gap)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            score++
            
            scoreLabel.text = String(score)
            
        
        } else {
            
            
            if gameOver == false {
                
                gameOver = true
            
                self.speed = 0
            
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Gap Over! Tap to play again"
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelContainer.addChild(gameOverLabel)
                
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameOver == false {
            
            // Drawing vectors of movement
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            bird.physicsBody!.applyImpulse(CGVectorMake(0, 50))
            
            
        } else {
            
            score = 0
            scoreLabel.text = "0"
            
            bird.physicsBody!.allowsRotation = false
            bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            bird.physicsBody!.velocity = CGVectorMake(0,0)
            
            movingObjects.removeAllChildren()
            
            makeBg()
            
            self.speed = 1
            
            gameOver = false
            
            labelContainer.removeAllChildren()
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
