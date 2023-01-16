//
//  Intersection.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/8/23.
//

import Foundation

class Intersection : Vector {
    
    let stroke1 : Stroke
    let stroke2 : Stroke
    let s1i1 : Int
    let s1i2 : Int
    let s2i1 : Int
    let s2i2 : Int
    let line_t1 : Float
    let line_t2 : Float
    
    init(x: Float,
                  y: Float,
                  stroke1: Stroke,
                  s1index1: Int,
                  s1index2: Int,
                  stroke2: Stroke,
                  s2index1: Int,
                  s2index2: Int,
                  line_t1: Float,
                  line_t2: Float
    ) {
        self.stroke1 = stroke1
        self.stroke2 = stroke2
        self.s1i1 = s1index1
        self.s1i2 = s1index2
        self.s2i1 = s2index1
        self.s2i2 = s2index2
        self.line_t1 = line_t1
        self.line_t2 = line_t2
        super.init(x: x, y: y)
    }
    
    func t1() -> Float {
        return Float(self.s1i1) / Float(self.stroke1.count())
    }
    
    func t2() -> Float {
        return Float(self.s2i1) / Float(self.stroke2.count())
    }
}
