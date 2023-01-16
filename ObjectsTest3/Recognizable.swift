//
//  Drawable.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/8/23.
//

import Foundation
import UIKit

protocol Recognizable {
    func draw(onContext c: CGContext)
    
    func boundingBox() -> Rectangle
    
    func gestureBox() -> Rectangle
    
    static func tryToRecognize(from strokes: [Stroke]) throws -> Recognizable?
}
