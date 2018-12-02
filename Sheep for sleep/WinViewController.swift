//
//  WinViewController.swift
//  Sheep for sleep
//
//  Created by Evgen on 17.10.2018.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {
    @IBOutlet weak var animateImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateImageView.loadGif(name: "sheepSleep2")

        // Do any additional setup after loading the view.
    }


    @IBAction func returnToSeconGame(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openFirstGame(_ sender: Any) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateInitialViewController()
        appdelegate.changeRootVC(vc: homeViewController!)
    }
    
}
