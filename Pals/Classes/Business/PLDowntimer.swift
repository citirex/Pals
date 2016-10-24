//
//  PLDowntimer.swift
//  Pals
//
//  Created by ruckef on 21.10.16.
//  Copyright © 2016 citirex. All rights reserved.
//

class PLDowntimer {
    var waitTime: NSTimeInterval

    convenience init() {
        self.init(waitTime: 0.5)
    }
    
    init(waitTime: NSTimeInterval) {
        self.waitTime = waitTime
    }
    
    private var completion : (()->())?
    private var timer: NSTimer?
    private var callCount = 0
    
    func wait(completion:()->()) {
        if self.completion == nil {
            PLLog("\(PLDowntimer.self) completion assigned")
            self.completion = completion
        }
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(waitTime, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
        callCount += 1
        PLLog("\(PLDowntimer.self) wait called \(callCount) times")
    }
    
    @objc private func timerFired() {
        PLLog("\(PLDowntimer.self) fired")
        completion?()
        completion = nil
        callCount = 0
    }
}