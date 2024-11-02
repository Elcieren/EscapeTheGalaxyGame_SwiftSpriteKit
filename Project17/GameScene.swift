//
//  GameScene.swift
//  Project17
//
//  Created by Eren Elçi on 2.11.2024.
//

import SpriteKit


class GameScene: SKScene , SKPhysicsContactDelegate {
    var starfiled: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel : SKLabelNode!
    
    var possinleEnemies = ["ball","hammer","tv","konsol"]
    var gameTimer : Timer?
    var isGamerOver = false
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        SetUpScene()
        
    }
    
    func SetUpScene() {
        backgroundColor = .black
        starfiled = SKEmitterNode(fileNamed: "starfield")!
        starfiled.position = CGPoint(x: 1024, y: 384)
        starfiled.advanceSimulationTime(10)
        addChild(starfiled)
        starfiled.zPosition = -1
        
        
        self.player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 100, y: 26)
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(creatEnemy), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGamerOver {
            score += 1
        }
    }
    
    @objc func creatEnemy(){
        guard let enemy = possinleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGamerOver {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = .aspectFill
            self.view?.presentScene(newScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()

        isGamerOver = true
        if isGamerOver == true {
            let gameOver = SKSpriteNode(imageNamed: "gameovers")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            gameOver.name = "game"
            addChild(gameOver)
            
        }
    }
}
