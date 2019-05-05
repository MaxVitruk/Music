//
//  CountdownController.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Foundation

protocol CountdownDelegate : class {
    func tick(_ tick : TimeInterval, percentage : Float)
    func becameInvalid()
    func timeIsUp()
}

class CountdownController {
    weak var delegate : CountdownDelegate?
    
    private(set)
    var timer : Timer?
    
    private(set)
    var countDown : TimeInterval = 0 {
        didSet {
            if self.countDown > overtime {
                delegate?.timeIsUp()
                self.countDown = 0
            }
        }
    }
    
    private(set)
    var overtime : TimeInterval
    
    private var percentage : Float {
        return Float(countDown) / Float(overtime)
    }
    
    init(overtime : TimeInterval, immediateStart : Bool = true) {
        self.overtime = overtime
        
        if immediateStart {
            start()
        }
    }
    
    func start(){
        if timer != nil {
            invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] t in
            guard let _self = self else { t.invalidate(); return }
            _self.countDown += 1
            _self.delegate?.tick(_self.countDown, percentage: _self.percentage)
        }
    }
    
    
    func invalidate() {
        timer?.invalidate()
        countDown = 0
        delegate?.becameInvalid()
    }
}
