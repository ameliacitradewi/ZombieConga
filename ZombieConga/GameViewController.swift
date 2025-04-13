//
//  GameViewController.swift
//  ZombieConga
//
//  Created by Amelia Citra on 12/04/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
	
	override func viewDidLoad() {
		let scene = GameScene(size: CGSize(width: 2556, height: 1179)) // creating scene
		let skView = self.view as! SKView // creating views
		skView.showsFPS = true // line 19 to 22 creating various options on views
		skView.showsNodeCount = true
		skView.ignoresSiblingOrder = true
		scene.scaleMode = .aspectFill
		skView.presentScene(scene) // presenting scene
	}
}
