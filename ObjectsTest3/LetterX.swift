//
//  RecognizedX.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/8/23.
//

import Foundation
import UIKit

class LetterX : Recognizable {
    let centerX: Float
    let centerY: Float
    let height: Float
    let width: Float
    
    init(atCenterX x: Float, atCenterY y: Float, withHeight height: Float, withWidth width: Float) {
        self.centerX = x
        self.centerY = y
        self.height = height
        self.width = width
    }
    
    func boundingBox() -> Rectangle {
        return Rectangle(atCenterX: centerX, atCenterY: centerY, withHeight: height, withWidth: width)
    }
    
    func gestureBox() -> Rectangle {
        return boundingBox()
    }
    
    
    func draw(onContext c: CGContext) {
//        c.rotate(by: CGFloat(orientation.radians))
//        let line1 = [CGPoint(x: CGFloat(self.centerX - self.width / 2), y: CGFloat(self.centerY + self.height / 2)),
//                     CGPoint(x: CGFloat(self.centerX + self.width / 2), y: CGFloat(self.centerY - self.height / 2)),
//        ]
//        let line2 = [CGPoint(x: CGFloat(self.centerX - self.width / 2), y: CGFloat(self.centerY - self.height / 2)),
//                     CGPoint(x: CGFloat(self.centerX + self.width / 2), y: CGFloat(self.centerY + self.height / 2)),
//        ]
        let boundingBox = self.boundingBox()
        let line1 = [boundingBox.topLeft().asCGPoint(), boundingBox.bottomRight().asCGPoint()]
        let line2 = [boundingBox.bottomLeft().asCGPoint(), boundingBox.topRight().asCGPoint()]
        c.strokeLineSegments(between: line1 + line2)
//        c.rotate(by: CGFloat(-orientation.radians))
    }
    
    static func containsRightNumberOf(strokes: [Stroke], rightNumber: Int) -> Bool {
        if strokes.count < rightNumber {
            print("Too few strokes. Supposed to be " + String(rightNumber) + " strokes.")
            return false
        } else if strokes.count > rightNumber {
            print("Too many strokes. Supposed to be " + String(rightNumber) + " strokes.")
            return false
        } else {
            return true
        }
    }
    
    static func tryToRecognize(from strokes: [Stroke]) throws -> Recognizable? {
        // Need to deal with beginning of line issues
        //        let clippedStrokes = strokes.map({stroke in stroke.clipped(clipFirst: 10, clipLast: 10)})
//        let clippedStrokes = strokes.map({stroke in stroke.clipEndsToHalfAverageDistance()})

        print("Trying to recognize an X!")
//        print("Stats:")
//        for i in 0..<clippedStrokes.count {
//            print("Average orientation of stroke")
//            print(clippedStrokes[i].averageOrientation())
//            print(clippedStrokes[i].orientationVariance())
//        }
//        return nil
//        if strokes.count != 2 {
//            print("Wrong number of strokes!")
//            return nil
//        }
        
        if !containsRightNumberOf(strokes: strokes, rightNumber: 2) {
            return nil
        }
        
        //        let clippedStrokes = strokes.map({stroke in stroke.clipped(clipFirst: 10, clipLast: 10)})
//        let clippedStrokes = strokes.map({stroke in stroke.clipEndsToHalfAverageDistance()})
        var clippedStrokes: [Stroke] = []
        
        for stroke in strokes {
            let windowSize = min(10, Int(stroke.count() / 2))
            guard let clipped = stroke.clipEndsToLowOrientationVariance(windowSize: windowSize, threshold: 0.3) else {
                print("Ends of stroke too far from a line!")
                print(stroke.orientationVariance())
                return nil
            }
            clippedStrokes.append(clipped)
        }

        
        // Test intersection
        let intersections = try strokes[0].intersections(other: strokes[1])
        if intersections.isEmpty {
            print("No intersection")
            return nil
        }
        else if intersections.count > 1 {
            print("Multiple intersections")
            return nil
        }
            
        let intersection = intersections[0]
        print("Intersection")
        print(intersection)
        
        if intersection.t1() < 0.2 || intersection.t1() > 0.8 || intersection.t2() < 0.2 || intersection.t2() > 0.8 {
            print("Intersection too far from center of stroke.")
            return nil
        }
        
        
        
//        if let i = intersections {
//            print("Intersection")
//            print(i)
//        } else {
//            print("No intersection")
//            return nil
//        }
        
        
        let arclen1 = strokes[0].arclength
        let arclen2 = strokes[1].arclength
        let relativeError = 2 * abs(arclen1 - arclen2) / (arclen1 + arclen2)
        if (relativeError > 0.5) {
            print("Strokes very different in size!")
            return nil
        }

        for stroke in clippedStrokes {
            if stroke.orientationVariance() > 0.3 {
//                assert(false)
                print("Stroke too far from a line!")
                print(stroke)
                print(stroke.orientationVariance())
                return nil
            }
        }

        let upRightStroke : Stroke
        let downRightStroke : Stroke
        if strokes[0].averageOrientation().flippedUp().radians > Float.pi / 2 {
            upRightStroke = clippedStrokes[1]
            downRightStroke = clippedStrokes[0]
        } else if strokes[1].averageOrientation().flippedUp().radians > Float.pi / 2 {
            upRightStroke = clippedStrokes[0]
            downRightStroke = clippedStrokes[1]
        } else {
            print("Strokes both lean left or both lean right!")
            return nil
        }

//        let relativeOrientation = clippedStrokes[1].averageOrientation().flippedUp().radians - clippedStrokes[0].averageOrientation().flippedUp().radians

//        let upRightStroke : Stroke
//        let downRightStroke : Stroke
//        if relativeOrientation > 0 {
//            upRightStroke = clippedStrokes[0]
//            downRightStroke = clippedStrokes[1]
//        } else {
//            upRightStroke = clippedStrokes[1]
//            downRightStroke = clippedStrokes[0]
//        }

        let upRightOrientation = upRightStroke.averageOrientation().flippedUp()
        let downRightOrientation = downRightStroke.averageOrientation().flippedUp()
//        let orientation = (upRightOrientation + downRightOrientation) / 2
        let angle = downRightOrientation - upRightOrientation

        if angle.radians > 2 * Float.pi / 3 {
            print("Angle too wide!")
            return nil
        }
        if angle.radians < Float.pi / 6 {
            print("Angle too narrow!")
            return nil
        }

        let allPoints = strokes[0].points() + strokes[1].points()
        let center = allPoints.reduce(Vector.zero(), {$0 + $1}) / Float(allPoints.count)
        let xs = allPoints.map({$0.x})
        let ys = allPoints.map({$0.y})


        return LetterX(atCenterX: center.x, atCenterY: center.y, withHeight: ys.max()! - ys.min()!, withWidth: xs.max()! - xs.min()!)
        
    }
}
