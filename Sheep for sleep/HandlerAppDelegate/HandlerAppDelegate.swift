//
//  HandlerAppDelegate.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 13.05.2018.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import Foundation

protocol HandlerApp {
    func appDidBecomeActive()
}

class HandlerAppDelegate: HandlerApp {
    var delegate: HandlerApp?
    static let sharedInstance = HandlerAppDelegate()
    func appDidBecomeActive() {
        delegate?.appDidBecomeActive()
    }
}
