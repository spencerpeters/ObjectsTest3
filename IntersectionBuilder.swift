//
//  IntersectionBuilder.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/15/23.
//

import Foundation

enum FinalizationError : Error {
    case MissingParameterError
}

class IntersectionBuilder {
    
    var stroke1 : Stroke?
    var stroke2 : Stroke?
    var x: Float?
    var y: Float?
    var s1i1 : Int?
    var s1i2 : Int?
    var s2i1 : Int?
    var s2i2 : Int?
    var line_t1 : Float?
    var line_t2 : Float?
    
    init() {}
    
    func finalize() throws -> Intersection {
        guard let fstroke1 = stroke1,
              let fstroke2 = stroke2,
              let fx = x,
              let fy = y,
              let fs1i1 = s1i1,
              let fs1i2 = s1i2,
              let fs2i1 = s2i1,
              let fs2i2 = s2i2,
              let fline_t1 = line_t1,
              let fline_t2 = line_t1
        else {
            throw FinalizationError.MissingParameterError
        }
        return Intersection(x: fx, y: fy, stroke1: fstroke1, s1index1: fs1i1, s1index2: fs1i2, stroke2: fstroke2, s2index1: fs2i1, s2index2: fs2i2, line_t1: fline_t1, line_t2: fline_t2)
    }
}
