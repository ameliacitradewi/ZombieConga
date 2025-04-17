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
	
	let playableRect: CGRect
	
	override init(size: CGSize) {
		let maxAspectRatio:CGFloat = 16.0/9.0 // 1
		let playableHeight = size.width / maxAspectRatio // 2
		let playableMargin = (size.height-playableHeight)/2.0 // 3
		playableRect = CGRect(x: 0, y: playableMargin,
							  width: size.width,
							  height: playableHeight) // 4
		super.init(size: size) // 5
	}
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented") // 6
	}
	
	override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background1")
		background.position = (CGPoint(x: size.width/2, y: size.height/2)) // to center it in the middle
		background.anchorPoint = CGPoint(x: 0.5, y: 0.5) // default
		background.zPosition = -1 // make sure to move the background to the back
		addChild(background) // add sprite to scene
		
		zombie.position = CGPoint(x: 400, y: 400)
//		zombie.setScale(0.4) // reduce the size using SKNode method
		addChild(zombie)
		
		let mySize = background.size
		print("Size: ", mySize)
		
		debugDrawPlayableArea()
	}
	
	func moveZombieToward(location: CGPoint) {
		let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y) // different length between zombie position vs tap position
		let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y)) // calculating offset vector length using Pythagorean theorem
		// normalizing the vector to correct direction and length
		let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
		
		velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec)
	}
	
//	func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
//		let amountToMove = CGPoint(x: velocity.x * CGFloat(deltaTime), y: velocity.y * CGFloat(deltaTime))
//		print("Amount to move:", amountToMove)
//		
//		sprite.position = CGPoint(x: sprite.position.x + amountToMove.x,
//								  y: sprite.position.y + amountToMove.y)
//	}
	// simplify to:
	func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
		let amountToMove = velocity * CGFloat(deltaTime)
		print("Amount to move: \(amountToMove)")
		sprite.position += amountToMove
	}
	
	override func update(_ currentTime: TimeInterval) {
		if lastUpdateTime > 0 {
			deltaTime = currentTime - lastUpdateTime
		} else {
			deltaTime = 0
		}
		lastUpdateTime = currentTime
		print("\(deltaTime*1000) milliseconds since last udpdate")
		
		moveSprite(sprite: zombie, velocity: velocity)
		boundsCheckZombie() // check if zombie in edge position
		rotate(sprite: zombie, direction: velocity) // rotate zombie to moving direction
		
		//		moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0))
		
		//		if let lastTouchLocation = lastTouchLocation {
		//			let diff = lastTouchLocation - zombie.position
		//			if (diff.length() <= zombieMovePointsPerSec * CGFloat(deltaTime)) {
		//				zombie.position = lastTouchLocation
		//				velocity = CGPointZero
		//			} else {
		//				moveSprite(sprite: zombie, velocity: velocity)
		//			}
		//		}
	}
	
	func sceneTouched(touchLocation: CGPoint) {
		moveZombieToward(location: touchLocation)
	}
	
	func debugDrawPlayableArea() {
		let shape = SKShapeNode()
		let path = CGMutablePath()
		path.addRect(playableRect)
		shape.path = path
		shape.strokeColor = SKColor.red
		shape.lineWidth = 4.0
		addChild(shape)
	}
	
	// rotate zombie following the movement using trigonometry
	func rotate(sprite: SKSpriteNode, direction: CGPoint) {
		sprite.zRotation = atan2(direction.y, direction.x) // trigonometry
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
	
	func boundsCheckZombie() {
		let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
		let topRight = CGPoint(x: size.width, y: playableRect.maxY)
		if zombie.position.x <= bottomLeft.x {
			zombie.position.x = bottomLeft.x
			velocity.x = -velocity.x
		}
		if zombie.position.x >= topRight.x {
			zombie.position.x = topRight.x
			velocity.x = -velocity.x
		}
		if zombie.position.y <= bottomLeft.y {
			zombie.position.y = bottomLeft.y
			velocity.y = -velocity.y
		}
		if zombie.position.y >= topRight.y {
			zombie.position.y = topRight.y
			velocity.y = -velocity.y
		}
	}
}
