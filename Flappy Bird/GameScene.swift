//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Richard Guerci on 04/10/2015.
//  Copyright (c) 2015 Richard Guerci. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var bird = SKSpriteNode()
	var background = SKSpriteNode()
	var pipe1 = SKSpriteNode()
	var pipe2 = SKSpriteNode()
	var scoreLabel = SKLabelNode()
	var gameOverLabel = SKLabelNode()
	var gameOver = false
	var score = 0
	
	enum CollisionType : UInt32 {
		case Bird = 1
		case Object = 2
		case Gap = 3
	}
	
	override func didMoveToView(view: SKView) {
		self.physicsWorld.contactDelegate = self
		
		/** Bird **/
		//Texture animation
		let birdTexture1 = SKTexture(imageNamed: "flappy1.png")
		let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
		let animation = SKAction.animateWithTextures([birdTexture1,birdTexture2], timePerFrame: 0.1)
		let makeBirdFlap = SKAction.repeatActionForever(animation)
		
		//Create bird
		bird = SKSpriteNode(texture: birdTexture1)
		bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
		bird.zPosition = 1
		bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture1.size().height/2)
		bird.physicsBody!.dynamic = true
		bird.physicsBody!.allowsRotation = false
		bird.physicsBody!.categoryBitMask = CollisionType.Bird.rawValue
		bird.physicsBody!.contactTestBitMask = CollisionType.Object.rawValue
		bird.physicsBody!.collisionBitMask = CollisionType.Object.rawValue
		bird.runAction(makeBirdFlap)
		
		/** Ground **/
		let ground = SKNode()
		ground.position = CGPoint(x: 0, y: 0)
		ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.width, 1))
		ground.physicsBody?.dynamic = false
		ground.physicsBody!.categoryBitMask = CollisionType.Object.rawValue
		ground.physicsBody!.contactTestBitMask = CollisionType.Object.rawValue
		ground.physicsBody!.collisionBitMask = CollisionType.Object.rawValue
		self.addChild(ground)
		
		//Add node to the scene
		self.addChild(bird)
		
		/** Background **/
		//Texture animation
		let bgTexture = SKTexture(imageNamed: "bg.png")
		let movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
		let replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
		let movebgForever = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))
		
		//Create background
		for var i: CGFloat = 0; i<3; i++ {
			background = SKSpriteNode(texture: bgTexture)
			background.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
			background.size.height = self.frame.height
			background.zPosition = 0
			background.runAction(movebgForever)
			
			//Add node to the scene
			self.addChild(background)
		}
		
		/** Score **/
		scoreLabel.fontName = "Helvetica"
		scoreLabel.fontSize = 60
		scoreLabel.text = "0"
		scoreLabel.fontColor = UIColor.whiteColor()
		scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 200)
		scoreLabel.zPosition = 5
		self.addChild(scoreLabel)
		
		/** GameOver **/
		gameOverLabel.fontName = "Helvetica"
		gameOverLabel.fontSize = 40
		gameOverLabel.text = "Game Over !"
		gameOverLabel.fontColor = UIColor.whiteColor()
		gameOverLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
		gameOverLabel.zPosition = 5
		
		//Run spamw pipe
		NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("addPipes"), userInfo: nil, repeats: true)
	}
	
	func addPipes(){
		//set gap height
		let gapHeight = bird.size.height*4
		//set random height
		let movmentAmount = arc4random() % UInt32(self.frame.height/2)
		let pipeOffset = CGFloat(movmentAmount) - self.frame.height/4
		//set pipe action
		let movePipe = SKAction.moveByX(-self.frame.width*2, y: 0, duration: NSTimeInterval(self.frame.width/100))
		let movePipeAndRemove = SKAction.sequence([movePipe,SKAction.removeFromParent()])
		
		/** Pipe 1 **/
		//Pipe Texture
		let pipeTexture1 = SKTexture(imageNamed: "pipe1.png")
		
		//Create pipe 1
		pipe1 = SKSpriteNode(texture: pipeTexture1)
		pipe1.name = "object"
		pipe1.position = CGPoint(x: self.frame.width+pipeTexture1.size().width, y: CGRectGetMidY(self.frame)+pipeTexture1.size().height/2 + gapHeight/2 + pipeOffset)
		pipe1.zPosition = 1
		pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture1.size())
		pipe1.physicsBody!.dynamic = false
		pipe1.physicsBody!.categoryBitMask = CollisionType.Object.rawValue
		pipe1.physicsBody!.contactTestBitMask = CollisionType.Object.rawValue
		pipe1.physicsBody!.collisionBitMask = CollisionType.Object.rawValue
		pipe1.runAction(movePipeAndRemove)
		
		//Add node to the scene
		self.addChild(pipe1)
		
		/** Pipe 2 **/
		//Pipe Texture
		let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
		
		//Create pipe 2
		pipe2 = SKSpriteNode(texture: pipeTexture2)
		pipe2.name = "object"
		pipe2.position = CGPoint(x: self.frame.width+pipeTexture2.size().width, y: CGRectGetMidY(self.frame)-pipeTexture2.size().height/2 - gapHeight/2 + pipeOffset)
		pipe2.zPosition = 1
		pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture2.size())
		pipe2.physicsBody!.dynamic = false
		pipe2.physicsBody!.categoryBitMask = CollisionType.Object.rawValue
		pipe2.physicsBody!.contactTestBitMask = CollisionType.Object.rawValue
		pipe2.physicsBody!.collisionBitMask = CollisionType.Object.rawValue
		pipe2.runAction(movePipeAndRemove)
		
		//Add node to the scene
		self.addChild(pipe2)
		
		/** Gap **/
		//Create gap
		let gap = SKNode()
		gap.name = "object"
		gap.position = CGPoint(x: self.frame.width+pipeTexture2.size().width, y: CGRectGetMidY(self.frame) + pipeOffset)
		gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight))
		gap.physicsBody!.dynamic = false
		gap.physicsBody!.categoryBitMask = CollisionType.Gap.rawValue
		gap.physicsBody!.contactTestBitMask = CollisionType.Gap.rawValue
		gap.physicsBody!.collisionBitMask = CollisionType.Gap.rawValue
		gap.runAction(movePipeAndRemove)
		
		//Add node to the scene
		self.addChild(gap)
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		if contact.bodyA.categoryBitMask == CollisionType.Gap.rawValue {
			contact.bodyA.node?.removeFromParent()
			score++
			scoreLabel.text = "\(score)"
		}
		else {
			if !gameOver {
				gameOver = true
				self.speed = 0.0
				self.addChild(gameOverLabel)
			}
		}
	}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if !gameOver {
			bird.physicsBody?.velocity = CGVectorMake(0, 0)
			bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
		}
		else {
			gameOver = false
			for node in self.children {
				if let sknode = node as SKNode? {
					if sknode.name == "object" {
						node.removeFromParent()
					}
				}
			}
			score = 0
			scoreLabel.text = "\(score)"
			bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
			bird.physicsBody?.velocity = CGVectorMake(0, 0)
			gameOverLabel.removeFromParent()
			self.speed = 1.0
		}
	}
   
    override func update(currentTime: CFTimeInterval) {
		
    }
}
