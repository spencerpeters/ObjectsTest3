//
//  Angle.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/8/23.
//

import Foundation

class Angle : CustomStringConvertible {
    
    let radians : Float
    
    init(inRadians angle: Float) {
        self.radians = Angle.canonicalize(inRadians: angle)
    }
    
    public var description: String {return String(self.radians)}
    
    func flippedUp() -> Angle {
        return Angle(inRadians: (self.radians + Float.pi).truncatingRemainder(dividingBy: Float.pi))
    }
        
    static func zero() -> Angle {
        return Angle(inRadians: 0.0)
    }
    
    static func canonicalize(inRadians angle: Float) -> Float {
        // Puts the result between -pi and pi
        let anglePlusPi = angle + Float.pi
        let anglePlusPiMinus2PiTo2Pi = anglePlusPi.truncatingRemainder(dividingBy: 2 * Float.pi)
        let anglePlusPi0To2Pi = (anglePlusPiMinus2PiTo2Pi + 2 * Float.pi).truncatingRemainder(dividingBy: 2 * Float.pi)
        let angleMinusPiToPi = anglePlusPi0To2Pi - Float.pi
        return angleMinusPiToPi
//        let angleInMinus2PiTo2Pi = angle.truncatingRemainder(dividingBy: 2 * Float.pi)
//        let angleInMinus2PiTo2Pi = angle.truncatingRemainder(dividingBy: 2 * Float.pi)
//        return (angleInMinus2PiTo2Pi + 2 * Float.pi).truncatingRemainder(dividingBy: 2 * Float.pi)
    }
    
    static func + (left: Angle, right: Angle) -> Angle {
        return Angle(inRadians: left.radians + right.radians)
    }
    
    static prefix func - (a: Angle) -> Angle {
        return Angle(inRadians: -a.radians)
    }
    
    static func - (left: Angle, right: Angle) -> Angle {
        return left + (-right)
    }
    
    static func * (a: Angle, s: Float) -> Angle {
        return Angle(inRadians: s * a.radians)
    }
    
    static func / (a: Angle, s: Float) -> Angle {
        return a * (1/s)
    }
}
