//
//  Triangle.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 12/17/22.
//

import UIKit
import Foundation

class Triangle {
    
    let x: Int
    let y: Int
    
    init(atX x: Int, atY y: Int) {
        self.x = x
        self.y = y
    }
    
    func draw(onContext c: CGContext) {
        c.beginPath()
        let location = CGPoint.init(x: self.x, y: self.y)
        c.move(to: location)
        
        c.addLine(to: CGPoint.init(x: 100 + location.x, y: 100 + location.y))
        c.addLine(to: CGPoint.init(x: 100 + location.x, y: 0 + location.y))
        
        c.closePath()
        
        c.setFillColor(UIColor.blue.cgColor)
        c.setStrokeColor(UIColor.green.cgColor)
        
        c.drawPath(using: CGPathDrawingMode.fillStroke)
    }    
}
