//
//  StarSmall.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 07.04.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class StarSmall: UIView {
    var starStrong: UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startAnimation(with delay: CGFloat) {
        starStrong?.removeFromSuperview()
        let image = UIImage(named: "starSmall")
        let star = UIImageView(image: image)
        star.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
        star.alpha = 0.1
        starStrong = star
        self.addSubview(star)
        
        UIView.animate(withDuration: 1, delay: TimeInterval(delay), options: [.repeat, .curveEaseInOut, .autoreverse], animations: {
            star.transform = CGAffineTransform(scaleX: 25,y: 25)
            star.alpha = 1
        }, completion: { _ in
            print("Test")
        })
        
    }
    


}
