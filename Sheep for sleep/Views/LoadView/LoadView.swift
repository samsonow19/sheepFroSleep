//
//  LoadView.swift
//  Sheep for sleep
//
//  Created by Evgen on 30.09.2018.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

protocol LoadViewDelegate: AnyObject {
    func timeOver()
}

private let wightLoadView: CGFloat = 20
private var sizeLoadView: CGSize = CGSize(width: 16, height: 30)

final class LoadView: UIView {
    
    weak var delegate: LoadViewDelegate?
    var loadingItems: [UIView] = []
    private var timer: Timer?
    private var indexTimer = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        deinitTimer()
    }
    
    func setupLoadView(wight: CGFloat) {
        let countLoadingItems: Int = Int(wight/wightLoadView)
        sizeLoadView.height = self.frame.height
        for i in 0...countLoadingItems {
            addLoadingView(with: i)
        }
        startLoading()
    }
    
    private func addLoadingView(with index: Int) {
    
        let start = index * Int(wightLoadView)
        
        let view: UIView = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6, green: 0.4862745098, blue: 0.7215686275, alpha: 1)
        view.clipsToBounds = true
        view.layer .cornerRadius = 6
        
        let point = CGPoint(x: start, y: 0)
        view.frame = CGRect(origin: point, size: sizeLoadView)
        loadingItems.append(view)
        self.addSubview(view)
        
    }
    //#colorLiteral(red: 0.9764705882, green: 0.8431372549, blue: 0.3058823529, alpha: 1)
    
    
    func startLoading() {
        indexTimer = loadingItems.count - 1
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loading), userInfo: nil, repeats: true)
        
    }
    
    @objc func loading() {
        
        if indexTimer > 0 {
            self.loadingItems[indexTimer].backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.8431372549, blue: 0.3058823529, alpha: 1)
        } else {
            deinitTimer()
            delegate?.timeOver()
        }
        indexTimer -= 1
    }
    
    func deinitTimer() {
        indexTimer = 0
        timer?.invalidate()
        timer = nil
    }
    
}
