//
//  TimedVector.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/8/23.
//

import Foundation

class TimedVector: Vector {
    
    let t: Float
    
    init(x: Float, y: Float, t:Float) {
        self.t = t
        super.init(x: x, y: y)
    }
}
