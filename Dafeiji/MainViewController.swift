//
//  MainViewController.swift
//  Dafeiji
//
//  Created by 陈凯 on 12/10/2016.
//  Copyright © 2016 陈凯. All rights reserved.
//

import UIKit
import SpriteKit

class MainViewController: UIViewController {

    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var pauseView: UIView!
    
    @IBOutlet weak var pauseView2TopConstraint: NSLayoutConstraint!
    
    @IBAction func pause(_ sender: UIButton) {
        (self.view as! SKView).isPaused = true
        resumeButton.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.pauseView2TopConstraint.priority = 999
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func resume(_ sender: UIButton) {
        (self.view as! SKView).isPaused = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.pauseView2TopConstraint.priority = 500
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func restart(_ sender: UIButton) {
        (self.view as! SKView).isPaused = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "restart_dafeiji"), object: nil)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.pauseView2TopConstraint.priority = 500
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseView2TopConstraint.priority = 500
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let skView = self.view as! SKView
        
        // for test
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let scene = MainScene(size: skView.bounds.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        
        skView.presentScene(scene)
        
        pauseButton.setBackgroundImage(UIImage(named: "BurstAircraftPause"), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameOver), name: NSNotification.Name(rawValue: "dafeiji_game_over"), object: nil)
    }
    
    func gameOver() {
        (self.view as! SKView).isPaused = true
        DispatchQueue.main.async {
            self.resumeButton.isHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.pauseView2TopConstraint.priority = 999
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
}
