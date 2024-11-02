## SwiftMapKit Uygulama Kullanımı
| MapKit 1 | MapKit 2 |
|---------|---------|
| ![Video 1](https://github.com/user-attachments/assets/f911d816-a7bd-4ef2-9d07-ad4f3ae53332) | ![Video 2](https://github.com/user-attachments/assets/ff77a6cc-e31f-4b5f-b4cd-67d56485e4f3) |

 <details>
    <summary><h2>Oyunun Amacı</h2></summary>
    Proje Amacı
   Bu oyunun amacı, oyuncunun ekrandaki düşman nesnelerinden kaçınarak mümkün olan en yüksek puanı elde etmesidir. Oyuncu karakteri, ekranın alt kısmında hareket ederken düşmanlar ekrandan gelir. Düşmanlarla çarpışmamak için hızlı bir refleks ve dikkat gerekmektedir. Oyun, puan kazanmayı teşvik ederken, çarpışma durumunda oyuncunun kaybetmesine neden olur
  </details>  

  <details>
    <summary><h2>Değişkenler ve Tanımlar</h2></summary>
    starfiled: Arka planda yıldızları simüle eden bir emitter düğümü.
     player: Oyuncu karakterini temsil eden sprite düğümü.
     scoreLabel: Oyuncunun puanını gösteren etiket.
     possinleEnemies: Ekranda düşman olarak belirebilecek nesnelerin isimlerini içeren bir dizi.
     gameTimer: Düşmanların oluşturulması için kullanılan zamanlayıcı.
     isGamerOver: Oyun bitip bitmediğini kontrol eden bir boolean değişkeni.
    score: Oyuncunun puanını tutan bir değişken. didSet özelliği ile puan değiştiğinde etiketin güncellenmesini sağlar.
    
    ```
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



    ```
  </details> 

  <details>
    <summary><h2>didMove(to:) Metodu</h2></summary>
    Sahne görüntülendiğinde çağrılır. SetUpScene() metodunu çağırarak sahneyi kurar.

    
    ```
        override func didMove(to view: SKView) {
        SetUpScene()
    }


    ```
  </details> 

  <details>
    <summary><h2>SetUpScene() Metodu</h2></summary>
   Arka plan rengini siyah olarak ayarlar.
   Yıldızların bulunduğu bir emitter düğümü (starfiled) oluşturur ve sahneye ekler.
   Oyuncu karakterini (player) oluşturur ve sahneye ekler. Ayrıca fiziksel özellikler ekleyerek çarpışma testlerine uygun hale getirir.
    Puan etiketini (scoreLabel) oluşturur ve sahneye ekler.
    Puanı sıfırlar.
    Fizik dünyası için yerçekimini sıfırlar ve çarpışma denetleyicisini ayarlar.
    Düşman nesnelerini oluşturmak için bir zamanlayıcı başlatır
    
    ```
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


    
    ```
  </details> 


  <details>
    <summary><h2>update(_:) Metodu</h2></summary>
    Her güncellemede (her frame'de) çağrılır.
    Ekrandan çıkan nesneleri (x konumu -300'den küçük olanlar) sahneden kaldırır.
    Oyun devam ediyorsa (oyun bitmemişse), puanı bir artırır.
    
    ```
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


    ```
  </details> 

  <details>
    <summary><h2>creatEnemy() Metodu</h2></summary>
    Rastgele bir düşman seçer ve yeni bir sprite oluşturur.
    Düşmanın pozisyonunu ayarlar ve sahneye ekler.
    Düşman için fiziksel özellikler ekler; hız ve açısal hız gibi.
    
    ```
        @objc func creatEnemy() {
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


    ```
  </details> 

  <details>
    <summary><h2>touchesMoved(_:with:) Metodu</h2></summary>
    Kullanıcı ekrana dokunduğunda oyuncunun pozisyonunu günceller.
    Oyuncunun ekranın üst veya alt sınırını aşmasını engeller.
    
    ```
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



    ```
  </details> 

  <details>
    <summary><h2>touchesBegan(_:with:) Metodu</h2></summary>
    Kullanıcı ekrana dokunduğunda eğer oyun bitmişse yeni bir sahne başlatır. Böylece kullanıcı yeni bir oyun oynayabilir.
    
    ```
              override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGamerOver {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = .aspectFill
            self.view?.presentScene(newScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }




    ```
  </details> 

  <details>
    <summary><h2>didBegin(_:) Metodu</h2></summary>
    Fiziksel çarpışma gerçekleştiğinde çağrılır.
    Oyuncu konumunda bir patlama efekti oluşturur.
    Oyuncu sprite'ını sahneden kaldırır.
    Oyunun sona erdiğini belirtir ve "game over" ekranını ekrana ekler.
    
    ```
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




    ```
  </details> 

  


<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Oyun Basladiktan sonra</h4>
            <img src="https://github.com/user-attachments/assets/601ac5a4-279d-4c79-95c5-a404d4e87b69" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Player Oyunu Kaybederse</h4>
            <img src="https://github.com/user-attachments/assets/156144a1-28d4-48c1-9436-0b4134506e0b" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
