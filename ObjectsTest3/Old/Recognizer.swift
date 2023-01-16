//
//  RecognizedObject.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 1/8/23.
//

import Foundation
import UIKit

protocol Recognizer {
    
    func tryToRecognizeFrom(strokes: [Stroke])
    
    func draw(onContext c: CGContext)
    
    func isRecognized() -> Bool
}
