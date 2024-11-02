//
//  SplashViewController.swift
//  Project17
//
//  Created by Eren Elçi on 2.11.2024.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: self.view.bounds)
                backgroundImage.image = UIImage(named: "spaceee1") // Arka plan resminizin adı
                backgroundImage.contentMode = .scaleAspectFill // Resmin ekran boyutuna göre ölçeklenmesini sağlar
                self.view.insertSubview(backgroundImage, at: 0)

        
    }
    
   
    @IBAction func playsButton(_ sender: Any) {
        playGame()
    }
    
    @objc func playGame() {
            // GameViewController'a geçiş yapın
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let gameVC = storyboard.instantiateViewController(identifier: "GameViewController") as? GameViewController {
                gameVC.modalPresentationStyle = .fullScreen // Tam ekran geçiş yapacak
                self.present(gameVC, animated: true, completion: nil)
            }
        }

}
