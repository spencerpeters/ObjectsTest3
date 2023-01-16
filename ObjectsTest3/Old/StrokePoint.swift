//
//  StrokePoint.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 12/28/22.
//

import Foundation
import UIKit

struct StrokePoint {
    var x : CGFloat
    var y : CGFloat
    var t : Float
    
    func asCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}
