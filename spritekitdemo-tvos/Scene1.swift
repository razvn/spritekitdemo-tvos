//
//  Scene1.swift
//  spritekitdemo-tvos
//
//  Created by Razvan on 22/05/2016.
//  Copyright © 2016 Razvan Bunea. All rights reserved.
//

import SpriteKit

class Scene1: SKScene {
    let myCamera = SKCameraNode()
    var maxX:CGFloat = 0
    let ship = SKSpriteNode(imageNamed:"Spaceship")
    var bgArray = [SKSpriteNode]()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let background1 = SKSpriteNode(imageNamed: "space-stars")
        background1.name = "BG1"
        background1.position  = CGPoint(x:self.frame.width/2 + (background1.frame.width - self.frame.width)/2, y:self.frame.height/2)
        bgArray.append(background1)
        
        let background2 = SKSpriteNode(imageNamed: "space-stars")
        background2.name = "BG2"
        background2.position  = CGPoint(x:background1.position.x + background1.frame.width + 200, y:self.frame.height/2)
        bgArray.append(background2)
        
        let background3 = SKSpriteNode(imageNamed: "space-stars")
        background3.name = "BG3"
        background3.position  = CGPoint(x:background2.position.x + background2.frame.width + 200, y:self.frame.height/2)
        bgArray.append(background3)
        
        maxX = background3.position.x + background3.frame.width
        
        print("bk1: \(background1.position), bk2: \(background2.position), bk3: \(background3.position)")
        self.addChild(background1)
        self.addChild(background2)
        self.addChild(background3)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if (self.childNodeWithName("SHIP") == nil) {
            ship.zRotation = CGFloat(-M_PI/2)
            ship.xScale = 0.5
            ship.yScale = 0.5
            ship.zPosition = 10
            ship.position = CGPointMake(self.frame.width/2, self.frame.height/2)
            ship.name = "SHIP"
        
            let action = SKAction.moveByX(500, y: 0, duration: 1)
            
            //myCamera.runAction(action)
            ship.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(ship)
        }
       
        if (self.childNodeWithName("CAMERA") == nil) {
            myCamera.position = ship.position
            myCamera.name = "CAMERA"
            addChild(myCamera)
            self.camera = myCamera
            
            let constraint = SKConstraint.distance(SKRange(constantValue: 0.0), toNode: ship)
            myCamera.constraints = [constraint]
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        //let action = SKAction.moveTo(ship.position, duration: 0.25)
        let shipX = ship.position.x
        if ( shipX > 0) {
            for bg in bgArray {
                //si la position du vaisseau est après le fond on déplace le background à maxX
                if shipX > bg.position.x + bg.frame.width + ship.frame.width/2 {
                    bg.position.x = maxX
                    maxX += bg.frame.width
                    //print("Bg: \(bg.name) déplacé en: \(bg.position.x)")
                }
            }
            createAsteroid()
        }
    }
    
    
    private func createAsteroid() {
        
        let randomApparence = arc4random_uniform(1000)
        
        if randomApparence > 970 {
            
            let randomRadius = arc4random_uniform(50) + 50
            
            let asteroid = SKShapeNode(circleOfRadius: CGFloat(randomRadius))
            asteroid.fillColor = .lightGrayColor()
            asteroid.name  = "ASTEROID"
            asteroid.zPosition = ship.zPosition + 1
            asteroid.position.x = ship.position.x + 1000
            
            let maxHeight = self.size.height - asteroid.frame.height
            asteroid.position.y = CGFloat(arc4random_uniform(UInt32(maxHeight))) + asteroid.frame.height/2
            
            
            self.addChild(asteroid)
        }
    }
}
