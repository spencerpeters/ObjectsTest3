//
//  Vector.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/8/23.
//

import Foundation

class Vector : CustomStringConvertible {
    let x: Float
    let y: Float
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    static func zero() -> Vector {
        return Vector(x: 0, y: 0)
    }
    
    public var description: String {return "<" + String(x) + "," + String(y) + ">"}
    
    func angle() -> Angle {
        if x == 0 {
            if y > 0 {
                return Angle(inRadians: -Float.pi / 2)
            } else if y < 0 {
                return Angle(inRadians: Float.pi / 2)
            } else {
                return Angle(inRadians: 0)
            }
        } else if x > 0 {
            return Angle(inRadians: atan(-y/x))
        } else {
            return Angle(inRadians: atan(-y/x) + Float.pi)
        }
    }
    
    func length() -> Float {
        return sqrt(x * x + y * y)
    }
    
    func asCGPoint() -> CGPoint {
        return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
    
    static func + (left: Vector, right: Vector) -> Vector {
        return Vector(x: left.x + right.x, y: left.y + right.y)
    }
    
    static prefix func - (v: Vector) -> Vector {
        return Vector(x: -v.x, y: -v.y)
    }
    
    static func - (left: Vector, right: Vector) -> Vector {
        return left + (-right)
    }
    
    static func * (v: Vector, s: Float) -> Vector {
        return Vector(x: s * v.x, y: s * v.y)
    }
    
    static func / (v: Vector, s: Float) -> Vector {
        return v * (1/s)
    }
}
