//
//  WheelViewController.swift
//  SpinTheWheelGame
//
//  Created by Shane Bersiek on 8/2/21.
//

import UIKit
import SpriteKit
import SwiftUI

class WheelViewController: UIViewController {
    
    @IBOutlet weak var spinButton: UIButton!
    var wheelRewards = [Reward]()
    
    @IBOutlet weak var tickerImgView: UIImageView!
    @IBOutlet weak var wheelView: Wheel!
    
    //MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
       
        createWheel()
        addtickerImage()
        customizeButton(button: spinButton)
        view.backgroundColor = screenBackgroundColor
        print("wheelrewards c = \(wheelRewards.count)")
    }
   
   
    //MARK: functions
    func customizeButton(button: UIButton){
        button.backgroundColor = pinkButtonColor
    }
    
    
    func addtickerImage(){
        guard let imageView = tickerImgView else {return}
        
        self.view.addSubview(imageView)
    }
    
    func createWheel(){
        guard let wheel = self.wheelView else {return}
        wheel.rewards = wheelRewards
        wheel.backgroundColor = UIColor.clear
        Wheel.makeViewCircle(view: wheel)
        wheel.layer.borderWidth = 5.0
        self.view.addSubview(wheel)
        wheel.center = self.view.center
    }

    func spinWheel(){
        guard let wheel = self.wheelView else {return}
        
        let rotateView = CABasicAnimation()
        let randonAngle = arc4random_uniform(361) + 360
        rotateView.fromValue = 0
        rotateView.toValue = Float(randonAngle) * Float(M_PI) / 180.0
        rotateView.duration = 1
        rotateView.repeatCount = 0
        rotateView.isRemovedOnCompletion = false
        rotateView.fillMode = CAMediaTimingFillMode.forwards
        rotateView.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        wheel.layer.add(rotateView, forKey: "transform.rotation.z")
    }
    func moveTicker(){
        let rotateView = CABasicAnimation()
        let randonAngle = arc4random_uniform(361) + 360
        rotateView.fromValue = 0
        rotateView.toValue = -0.3
        rotateView.duration = 0.3
        rotateView.repeatCount = 9
        rotateView.speed = 3
        rotateView.isRemovedOnCompletion = false
        rotateView.fillMode = CAMediaTimingFillMode.forwards

        rotateView.isRemovedOnCompletion = true
        rotateView.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.tickerImgView.layer.add(rotateView, forKey: "transform.rotation.z")
    }
    //MARK: IBActions
    @IBAction func spinButtonTapped(_ sender: UIButton) {
        moveTicker()
        spinWheel()
    }
}




