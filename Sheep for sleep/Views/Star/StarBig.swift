//
//  Star.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 07.04.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class StarBig: UIView {
    var starStrong: UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func startAnimation(with delay: CGFloat) {
        
        starStrong?.removeFromSuperview()
        let image = UIImage(named: "starBig")
        let star = UIImageView(image: image)
        star.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
        star.alpha = 0.1
        starStrong = star
        self.addSubview(star)

        UIView.animate(withDuration: 1.5, delay: TimeInterval(delay), options: [.repeat, .curveEaseInOut, .autoreverse], animations: {
            star.transform = CGAffineTransform(scaleX: 15, y: 15)
            star.alpha = 1
        }, completion: nil)
        
    }
    
    //TODO: самую левую большую 1.7

}
