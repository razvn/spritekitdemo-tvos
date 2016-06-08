//
//  Scene2.swift
//  spritekitdemo-tvos
//
//  Created by Razvan on 25/05/2016.
//  Copyright © 2016 Razvan Bunea. All rights reserved.
//

import SpriteKit

class Scene2: SKScene, SKPhysicsContactDelegate {
    ////12 - Contacts
    //définition des masques
    let BalleCat   : UInt32 = 0x1 << 0
    let PalletCat : UInt32 = 0x1 << 1
    let BordCat : UInt32 = 0x1 << 2
    let SpriteCat : UInt32 = 0x1 << 3
    
    override func didMoveToView(view: SKView) {
        
        let rayonBalle:CGFloat = 30
        
        //creation d'un Sprite Rond
        let balle = SKShapeNode(circleOfRadius: rayonBalle)
        balle.fillColor = .redColor()
        balle.name = "BALLE"
        
        ///////1
        //balle.position = CGPointZero
        
        ////// 2
        balle.position = CGPointMake(self.frame.width/2, self.frame.height - rayonBalle)
        
        addChild(balle)
        
        //////3
        //creation du monde physique
        self.physicsWorld.gravity = CGVectorMake(0,0) // initial -9.8.
        
        //////4
        //ajout du physics body à la balle
        let balleBody = SKPhysicsBody(circleOfRadius: rayonBalle)
        
        /////6
        balleBody.friction = 0
        balleBody.restitution = 1 //collision completement élastique -> rebond avec la même force que l'impact
        balleBody.linearDamping = 0 //simule la friction de l'air ou fluide en réduisant la vélocité du compts
        balleBody.angularDamping = 0 //comme pour les frictions angulaires
        /////6-end
        
        balle.physicsBody = balleBody
        
        //////5
        //ajout du phyics body sur les bords de la frame
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        //pas de friction pour pas relentir la bare
        borderBody.friction = 0
        
        self.physicsBody = borderBody
        
        //// 7 - mofifier le linearDamping
        
        //// 8 -  sans gravite
        
        //// 9 - sans gravité avec impulse
        
        balle.physicsBody!.applyImpulse(CGVectorMake(300.0, -300.0))
        
        
        
        ////10 - ajout du pallet
        let pallet = SKShapeNode(rect: CGRect(x: -rayonBalle*5, y: -rayonBalle/2, width: rayonBalle*10, height: rayonBalle))
        pallet.fillColor = .yellowColor()
        pallet.position = CGPointMake(self.frame.width/2, 50)
        addChild(pallet)
        
        ////11 - physicsbody du pallet
        let palletBody = SKPhysicsBody(rectangleOfSize: pallet.frame.size)
        palletBody.dynamic = false // il ne bouge pas lors de l'impact, ni impacté par la gravité
        palletBody.friction = 0
        palletBody.restitution = 1  //repond avec la même force
        pallet.physicsBody = palletBody
        
        
        ////12 - Contacts
        //définition des masques
        //let BalleCat   : UInt32 = 0x1 << 0
        //let PalletCat : UInt32 = 0x1 << 1
        //let BordCat : UInt32 = 0x1 << 2
        
        
        //affectation des masques aux differents corps
        balle.physicsBody?.categoryBitMask = BalleCat
        pallet.physicsBody?.categoryBitMask = PalletCat
        self.physicsBody?.categoryBitMask = BordCat
        
        //ajout des masques du contact à tester pour la balle
        balle.physicsBody?.contactTestBitMask = PalletCat | BordCat
        
        //déclaration du delegate des contacts
        self.physicsWorld.contactDelegate = self
        
        
        ////13 - ajouter son
        //se fait dans le contact
        
        
        ////14 - creation d'une jointure
        
        let attache = SKShapeNode(rect: CGRectMake(-rayonBalle/2, -rayonBalle/2 , rayonBalle, rayonBalle))
        attache.fillColor = .greenColor()
        attache.position = CGPointMake(self.frame.width/4, self.frame.height - attache.frame.height*2)
        addChild(attache)
        let attacheBody = SKPhysicsBody(rectangleOfSize: attache.frame.size)
        attacheBody.dynamic = false // il ne bouge pas lors de l'impact
        attacheBody.friction = 0
        attacheBody.restitution = 1
        attache.physicsBody = attacheBody
        
        let maJointure = SKPhysicsJointLimit.jointWithBodyA(attacheBody, bodyB: balleBody, anchorA: attache.position, anchorB: balle.position)
        maJointure.maxLength = self.frame.width - attache.position.x
        
        self.physicsWorld.addJoint(maJointure)
        //autmanter l'impulse d'origine
        balle.physicsBody!.applyImpulse(CGVectorMake(3000.0, -300.0))
        
        
        /////15 - ajout du touch pour ajouter un impluse
        
        /////17 - ajout d'un sprite
        let sprite = SKSpriteNode(imageNamed: "Sprite")
        sprite.position = CGPointMake(self.frame.width/4, self.frame.height/2)
        sprite.name = "SPRITE"
        

        let spriteBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        spriteBody.dynamic = true // il ne bouge pas lors de l'impact
        spriteBody.friction = 0
        spriteBody.restitution = 1
        
        sprite.physicsBody = spriteBody
        addChild(sprite)
        
        
        
        /////18 - créer un emitter
        
        
        /////19 - afficher l'emitter lorsque sprite touche un bord
        
        sprite.physicsBody?.categoryBitMask = SpriteCat
        sprite.physicsBody?.contactTestBitMask = PalletCat
        
        //détecte si on a appuyé sur play pour réafficher la sprite
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(Scene2.tap(_:)))
        tapRecogniser.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        
        self.view?.addGestureRecognizer(tapRecogniser)
        
        //
        
    }
    
    ///12 - methode du delegate de gestion des contacts
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        print("cat bodyA: \(contact.bodyA.categoryBitMask) - bodyB: \(contact.bodyB.categoryBitMask)")
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BalleCat && secondBody.categoryBitMask == PalletCat {
            print("Balle a touché le pallet")
            ////13 - lecture de son
            runAction(SKAction.playSoundFileNamed("point.m4a", waitForCompletion: false))
        }
        
        if firstBody.categoryBitMask == BalleCat && secondBody.categoryBitMask == BordCat {
            print("Balle a touché le bord")
        }
        
        if firstBody.categoryBitMask == PalletCat && secondBody.categoryBitMask == SpriteCat {
            
            //on cherche le sprite pour pour appliquer des actions
            if let sprite = childNodeWithName("SPRITE") {
                sprite.physicsBody = nil;
                
                //action de fadeout
                let fadeOutSprite = SKAction.fadeOutWithDuration(0.2)
                //action lecture d'un son
                let playExplosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
                //action execution d'un code - ici suppression de l'emitter à la fin
                let explosionRemove = SKAction.runBlock({
                    if let exp = self.childNodeWithName("EXPLOSION") {
                        exp.removeFromParent()
                    }
                })
                
                //emitter: chargement et affichage
                let explosionPath = NSBundle.mainBundle().pathForResource("Explosion", ofType: "sks")
                let explosionNode = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionPath!) as! SKEmitterNode
                explosionNode.position = contact.contactPoint
                explosionNode.name = "EXPLOSION"
                
                self.addChild(explosionNode)
                
                //Création d'une action qui groupe plusieurs actions executées en simultané
                let groupAction = SKAction.group([playExplosionSound, fadeOutSprite])
                
                //Création d'une action qui groupe plusieurs actions exécutées une après l'autre
                let sequenceExplosion = SKAction.sequence([SKAction.waitForDuration(0.7), SKAction.fadeOutWithDuration(0.3), explosionRemove])
                
                //execution des actions sur le sprite
                sprite.runAction(groupAction)
                
                //execution des action sur l'exploqion
                explosionNode.runAction(sequenceExplosion)
                
            }
            
            
            print("Sprite a touché le bord")
        }
    }
    
    
    /////15

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if let balle = childNodeWithName("BALLE") {
            let randomX = CGFloat(arc4random_uniform(1000) + 500)
            let randomY = CGFloat(arc4random_uniform(1000)) * (-1)
            balle.physicsBody!.applyImpulse(CGVectorMake(randomX, randomY))
        }
    }
    
    
    func tap(gesture: UITapGestureRecognizer) {
        if let sprite  = childNodeWithName("SPRITE") as? SKSpriteNode {
            //on le rajoute que si son alpha est à 0 cad le fadeout a fini
            if sprite.alpha == 0 {
                //position random
                let maxxpos = UInt32(self.frame.width - sprite.frame.height)
                let maxypos = UInt32(self.frame.height - sprite.frame.height)
                sprite.position = CGPointMake(CGFloat(arc4random_uniform(maxxpos)) + sprite.frame.height, CGFloat(arc4random_uniform(maxypos)) + sprite.frame.height)
                
                //on le fait apparaitre
                sprite.runAction(SKAction.fadeInWithDuration(0.5))
                
                //on lui ajoute le corps physiques
                let spriteBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
                spriteBody.dynamic = true // il ne bouge pas lors de l'impact
                spriteBody.friction = 0
                spriteBody.restitution = 1
                
                sprite.physicsBody = spriteBody
                
                //et les masques de collision
                sprite.physicsBody?.categoryBitMask = SpriteCat
                sprite.physicsBody?.contactTestBitMask = PalletCat
                
                //applique un impulse poue la faire un peu bouger
                let randomX = CGFloat(arc4random_uniform(1000)) - 500
                let randomY = CGFloat(arc4random_uniform(1000)) * (-1)
                sprite.physicsBody!.applyImpulse(CGVectorMake(randomX, randomY))

            }
            
        }
    }
    

}
