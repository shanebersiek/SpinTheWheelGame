//
//  ViewController.swift
//  SpinTheWheelGame
//
//  Created by Shane Bersiek on 8/2/21.
//

import UIKit


class FirstViewController: UIViewController {
    
    var wheelRewards = [Reward]()
    
    @IBOutlet weak var spinTheWheelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         getWheelRewards()
         customizeButton()
    }
    
    @IBAction func spinTheWheelBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "WheelViewController") as WheelViewController

        vc.wheelRewards = wheelRewards
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func customizeButton(){
        spinTheWheelBtn.backgroundColor = colorPalate.pinkButtonColor
        spinTheWheelBtn.roundedButton()
    }
    
    func getWheelRewards(){
        APIManager().fetchAllPosts { [weak self] (result) in
            switch result {
            case .success(let rewards):
                self?.wheelRewards = rewards
            case .failure(let error):
                print(error)
            }
        }
    }
    

}
