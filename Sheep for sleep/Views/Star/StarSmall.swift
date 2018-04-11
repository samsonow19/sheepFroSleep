//
//  StarSmall.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 07.04.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class StarSmall: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startAnimation(with delay: CGFloat) {
        let image = UIImage(named: "starSmall")
        let star = UIImageView(image: image)
        star.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
        star.alpha = 0.1
        self.addSubview(star)
        
        UIView.animate(withDuration: 0.7, delay: TimeInterval(delay), options: [.repeat, .curveEaseInOut, .autoreverse], animations: {
            star.transform = CGAffineTransform(scaleX: 30,y: 30)
            star.alpha = 1
        }, completion: nil)
        
    }

}
