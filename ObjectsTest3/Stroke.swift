//
//  Stroke.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/7/23.
//

import Foundation
import UIKit

class Stroke {
    let sequence : VectorSequence
    let differences : VectorSequence
    let distances : [Float]
    let orientations : [Angle]
    let angles : [Angle]
    let arclength : Float
    
    init(sequence : VectorSequence) {
        self.sequence = sequence
        self.differences = sequence.differences()
        self.distances = sequence.distances()
        self.angles = sequence.angles()
        self.orientations = differences.angles()
        self.arclength = differences.vectors.reduce(0, {sum, next in sum + next.length()})
    }
    
    func points() -> [Vector] {
        return self.sequence.vectors
    }
    
    func start() -> Vector {
        return self.sequence.vectors[0]
    }
    
    func count() -> Int {
        return self.sequence.count()
    }
        
    func clipped(clipFirst: Int, clipLast: Int) -> Stroke {
        if clipFirst + clipLast >= self.count() {
            return self
        }
        
        print("Clipping")
        let points = self.points()
        var clippedPoints : [Vector] = []
        for i in 0..<points.count {
            if i >= clipFirst && i < points.count - clipLast {
                clippedPoints.append(points[i])
            }
        }
        return Stroke(sequence: VectorSequence(vectors: clippedPoints))
    }
    
    func clipEndsToHalfAverageDistance() -> Stroke {
        let d = averageDistance()
        var i = 0
        while i < self.distances.count && self.distances[i] < d/2 {
            i = i + 1
        }
        var j = 1
        while j <= self.distances.count && self.distances[self.distances.count - j] < d/2 {
            j = j + 1
        }
        return clipped(clipFirst: i, clipLast: j-1)
    }
    
    func differencesCount() -> Int {
        return self.count() - 1
    }
    
    func clipEndsToLowOrientationVariance(windowSize: Int, threshold: Float) -> Stroke? {
        var foundStart = false
        var foundEnd = false
        var i = 0
        while i < self.differencesCount() - windowSize {
            let variance = orientationVarianceOfWindow(start: i, stop: i + windowSize)
            if variance < threshold {
                foundStart = true
                break
            }
            i += 1
        }
        var j = self.differencesCount()
        while j >= windowSize {
            let variance = orientationVarianceOfWindow(start: j - windowSize, stop: j)
            if variance < threshold {
                foundEnd = true
                break
            }
            j -= 1
        }
        if !foundStart || !foundEnd {
            return nil
        }
        print("clipped between " + String(i) + " and " + String(j))
        
        return clipped(clipFirst: i, clipLast: self.count() - j)
    }
    
    func orientationVarianceOfWindow(start: Int, stop: Int) -> Float {
        let windowDifferences = Array(self.differences.vectors[start..<stop])
        let averageOrientation = VectorSequence.average(vectors: windowDifferences).angle()
        let windowOrientations = Array(self.orientations[start..<stop])
        let squaredErrors = windowOrientations.map({($0 - averageOrientation).radians * ($0 - averageOrientation).radians})
        let variance = squaredErrors.reduce(0.0, {$0 + $1}) / Float(squaredErrors.count)
        return variance
    }
    
    
    func orientationVariance() -> Float {
        let average = self.averageOrientation()
        
        let squaredErrors = orientations.map({($0 - average).radians * ($0 - average).radians})
        return squaredErrors.reduce(0.0, {$0 + $1}) / Float(squaredErrors.count)
    }
    
    func orientationDeviation() -> Float {
        let average = self.averageOrientation()
        let errors = orientations.map({abs(($0 - average).radians)})
        return errors.reduce(0.0, {$0 + $1}) / Float(errors.count)
    }
    
    func averageOrientation() -> Angle {
        print(orientations)
//        return Angle(inRadians: orientations.reduce(0.0, {$0 + $1.radians}) / Float(orientations.count))
        return VectorSequence.average(vectors: differences.vectors).angle()
    }
    
    func averageDistance() -> Float {
        return distances.reduce(0.0, {$0 + $1}) / Float(distances.count)
    }
    
    
    static func lineSegmentIntersection(start1: Vector, end1: Vector, start2: Vector, end2: Vector) -> IntersectionBuilder? {
        // Perturb to prevent zero division lol
        let x1 = start1.x + 1e-8
        let y1 = start1.y - 2e-8
        let a1 = end1.x - start1.x + 3e-8
        let b1 = end1.y - start1.y - 4e-8
        let x2 = start2.x + 5e-8
        let y2 = start2.y - 6e-8
        let a2 = end2.x - start2.x + 7e-8
        let b2 = end2.y - start2.y - 8e-8
        
        let slopeDifference = a2/a1 - b2/b1
        if abs(slopeDifference) < 1e-15 {
            return nil
        } else {
            let t2 = ((y2 - y1) / b1 - (x2 - x1) / a1) / slopeDifference
            if t2 < 0 || t2 > 1 {
                return nil
            }
            // To get t1, interchange 1s and 2s
            let t1 = ((y1 - y2) / b2 - (x1 - x2) / a2) / (a1 / a2 - b1 / b2)
            if t1 < 0 || t1 > 1 {
                return nil
            }
//            return Vector(x: x2 + a2 * t2, y: y2 + b2 * t2)
            let x = x2 + a2 * t2
            let y = y2 + b2 * t2
            let builder = IntersectionBuilder()
            builder.x = x
            builder.y = y
            builder.line_t1 = t1
            builder.line_t2 = t2
            return builder
        }
    }
    
    // TODO make intersection object with more information
    // TODO return all intersections
    func intersections(other: Stroke) throws -> [Intersection] {
        var intersections : [IntersectionBuilder] = []
        let myPoints = self.points()
        let otherPoints = other.points()
        for i in 0..<self.count() - 1 {
            for j in 0..<other.count() - 1 {
                if let intersection = Stroke.lineSegmentIntersection(start1: myPoints[i], end1: myPoints[i+1], start2: otherPoints[j], end2: otherPoints[j+1]) {
                    intersection.stroke1 = self
                    intersection.stroke2 = other
                    intersection.s1i1 = i
                    intersection.s1i2 = i + 1
                    intersection.s2i1 = j
                    intersection.s2i2 = j + 1
                    intersections.append(intersection)
                }
            }
        }
        return try intersections.map({try $0.finalize()})
    }
}
