//
//  Square.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 12/17/22.
//

import UIKit
import Foundation

class Square {
    
    var location: CGPoint
    let sidelength: CGFloat
    var toggled: Bool
    
    init(at location: CGPoint) {
//        self.sidelength = 100
        self.sidelength = 5
//        self.location = location
        self.toggled = false
        self.location = CGPoint.zero
        self.setLocation(location: location)
    }
    
    func setLocation(location: CGPoint) {
        self.location = CGPoint(x: location.x - sidelength / 2, y: location.y - sidelength / 2)
    }
    
    func draw(onContext c: CGContext) {
        c.beginPath()
        c.move(to: CGPoint.init(x: location.x, y: location.y))
        
        c.addLine(to: CGPoint.init(
            x: sidelength + location.x,
            y: location.y))
        c.addLine(to: CGPoint.init(
            x: sidelength + location.x,
            y: sidelength + location.y))
        c.addLine(to: CGPoint.init(
            x: location.x,
            y: sidelength + location.y))
        
        c.closePath()
        
        if self.toggled {
            c.setFillColor(UIColor.blue.cgColor)
        } else {
            c.setFillColor(UIColor.orange.cgColor)
        }
        
        c.drawPath(using: CGPathDrawingMode.fill)
    }
    
    func contains(_ p: CGPoint) -> Bool {
        return p.x >= location.x && p.x <= location.x + sidelength && p.y >= location.y && p.y <= location.y + sidelength
    }
    
    func toggle() {
        toggled = !toggled
    }
}
