//
//  Rectangle.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/14/23.
//

import Foundation

class Rectangle {
    
    let centerX: Float
    let centerY: Float
    let width: Float
    let height: Float
    
    init(atCenterX centerX: Float, atCenterY centerY: Float, withHeight height: Float, withWidth width : Float) {
        self.centerX = centerX
        self.centerY = centerY
        self.width = width
        self.height = height
    }
    
    func corner(isRight: Bool, isBottom: Bool) -> Vector {
        return Vector(x: self.centerX + (self.width / 2) * Rectangle.signOf(isRight), y: self.centerY + (self.height / 2) * Rectangle.signOf(isBottom))
    }
    
    func topLeft() -> Vector {
        return corner(isRight: false, isBottom: false)
    }
    func topRight() -> Vector {
        return corner(isRight: true, isBottom: false)
    }
    func bottomLeft() -> Vector {
        return corner(isRight: false, isBottom: true)
    }
    func bottomRight() -> Vector {
        return corner(isRight: true, isBottom: true)
    }
    
    func center() -> Vector {
        return Vector(x: centerX, y: centerY)
    }
                      
    static func signOf(_ direction: Bool) -> Float {
        if direction {
            return 1.0
        } else {
            return -1.0
        }
    }
    
}
