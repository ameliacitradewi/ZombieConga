//
//  GameScene.swift
//  ZombieConga
//
//  Created by Amelia Citra on 12/04/25.
//

import SpriteKit

class GameScene: SKScene {
	let zombie = SKSpriteNode(imageNamed: "zombie1")
	
	var lastUpdateTime: TimeInterval = 0
	var deltaTime: TimeInterval = 0
	
	let zombieMovePointsPerSec: CGFloat = 480.0
	var velocity = CGPoint.zero
	
	var lastTouchLocation: CGPoint?
	
	override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background1")
		background.position = (CGPoint(x: size.width/2, y: size.height/2)) // to center it in the middle
		background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default
		background.zPosition = -1 // make sure to move the background to the back
		addChild(background) // add sprite to scene
		
		zombie.position = CGPoint(x: 400, y: 400)
		zombie.setScale(0.4) // reduce the size using SKNode method
		addChild(zombie)
		
		let mySize = background.size
		print("Size: ", mySize)
	}
	
	func moveZombieToward(location: CGPoint) {
		let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
		let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
		let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
		
		velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)
	}
	
	func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
		let amountToMove = CGPoint(x: velocity.x * CGFloat(deltaTime), y: velocity.y * CGFloat(deltaTime))
		print("Amount to move:", amountToMove)
		
		sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
								  y: sprite.position.y + amountToMove.y)
	}
	
	override func update(_ currentTime: TimeInterval) {
		if lastUpdateTime > 0 {
			deltaTime = currentTime - lastUpdateTime
		} else {
			deltaTime = 0
		}
		lastUpdateTime = currentTime
		print("\(deltaTime*1000) milliseconds since last udpdate")
		
//		moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
		
		if let lastTouchLocation = lastTouchLocation {
			let diff = lastTouchLocation - zombie.position
			if (diff.length() <= zombieMovePointsPerSec * CGFloat(deltaTime)) {
				zombie.position = lastTouchLocation
				velocity = CGPointZero
			} else {
				moveSprite(sprite: zombie, velocity: velocity)
			}
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		
		let touchLocation = touch.location(in: self)
		lastTouchLocation = touchLocation
		moveZombieToward(location: touchLocation)
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		
		let touchLocation = touch.location(in: self)
		lastTouchLocation = touchLocation
		moveZombieToward(location: touchLocation)
	}
}
