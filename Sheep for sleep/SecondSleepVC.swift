//
//  SecondSleepVC.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 09.04.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class SecondSleepVC: UIViewController {

    @IBOutlet weak var sheepImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sheepImage.loadGif(name: "sheepSleep2")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hero.dismissViewController()
            //elf.dismiss(animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func close(_ sender: Any) {
        self.hero.dismissViewController()
        //dismiss(animated: false, completion: nil)
    }
}
