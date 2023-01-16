//
//  VectorFunction.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/8/23.

//

import Foundation

class VectorSequence {
    
    let vectors: [Vector]
    
    init(vectors: [Vector]) {
        self.vectors = vectors
    }
    
    func differences() -> VectorSequence {
        var result : [Vector] = []
        for i in 1..<vectors.count {
            result.append(vectors[i] - vectors[i-1])
        }
        return VectorSequence(vectors: result)
//        return VectorSequence(vectors: VectorSequence.pairwiseCombine(vectors: self.vectors, combiner: {$0 - $1}))
    }
    
    func distances() -> [Float] {
        return self.differences().vectors.map({$0.length()})
    }
    
    func angles() -> [Angle] {
        return self.vectors.map({$0.angle()})
    }
    
    func count() -> Int {
        return self.vectors.count
    }
    
    func isEmpty() -> Bool {
        return self.vectors.isEmpty
    }
    
    func blur(gaussianWidth s: Int) -> VectorSequence {
        var result : [Vector] = []
        for i in 0..<vectors.count {
            var windowVectors : [Vector] = []
            for j in (i-2*s)..<(i+2*s + 1) {
                if j >= 0 && j < vectors.count {
                    let weight = exp(-Float.pi * Float((j - i) * (j - i) / (s * s)))
                    windowVectors.append(vectors[i] * weight)
                }
            }
            result[i] = VectorSequence.average(vectors: windowVectors)
        }
        return VectorSequence(vectors: result)
    }
    
//    static func pairwiseCombine(vectors: [Vector], combiner: (Vector, Vector) -> Vector) -> [Vector] {
//        var result : [Vector] = []
//        for i in 1..<vectors.count {
//            result.append(combiner(vectors[i], vectors[i-1]))
//        }
//        return result
//    }
    
    static func average(vectors: [Vector]) -> Vector {
        var sum = Vector.zero()
        for v in vectors {
            sum = sum + v
        }
        sum = sum / Float(vectors.count)
        return sum
    }
}
