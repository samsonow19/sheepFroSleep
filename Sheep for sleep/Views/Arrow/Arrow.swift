//
//  Arrow.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 31.03.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class Arrow: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startAnimation()
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .curveEaseInOut, .autoreverse], animations: {
            self.center = CGPoint(x:  self.center.x + 10 , y: self.center.y - 10)
        }, completion: nil)
    }
    
}
