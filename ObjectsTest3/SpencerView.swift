//
//  SpencerView.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 12/26/22.
//

import Foundation
import UIKit

class SpencerView : UIView {
    
//    var squares: [Square] = []
//    var clickedSquares: [Square] = []
    var currentStroke : [TimedVector] = []
    var strokes : [Stroke] = []
    let button : UIButton = UIButton(frame: CGRect(x: 100,
                                                   y: 100,
                                                   width: 200,
                                                   height: 60))
    var objects : [Recognizable] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        button.setTitle("Clear",
                        for: .normal)
        
        button.setTitleColor(.systemBlue,
                             for: .normal)
        
        button.backgroundColor = UIColor.lightGray
        
        button.addTarget(self,
                         action: #selector(buttonAction),
                         for: .touchUpInside)
        
        self.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func buttonAction() {
//        button.setTitle("Clicked", for: .normal)
        strokes = []
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
//        print(squares.count)
        let c = UIGraphicsGetCurrentContext()!
        // Since called from a UIView, this first pushes the view's context on the stack (!) So there is no need to jam the result into some property of the view.
//        for square in squares {
//            square.draw(onContext: c)
//        }
//        for point in stroke {
////            c.setFillColor(CGColor.init)
//            c.fill(CGRect(x: point.x, y: point.y, width: 5, height: 5))
//        }
        var toDraw : [[Vector]] = []
        toDraw.append(currentStroke)
        for stroke in strokes {
            toDraw.append(stroke.sequence.vectors)
        }
        for stroke in toDraw {
            if !stroke.isEmpty {
                var maxDist = Float.zero
                for i in 0..<stroke.count - 1 {
                    let point = stroke[i]
                    let nextPoint = stroke[i + 1]
                    let dist = sqrt((point.x - nextPoint.x) * (point.x - nextPoint.x) + (point.y - nextPoint.y) * (point.y - nextPoint.y))
                    if dist > maxDist {
                        maxDist = dist
                    }
                }
                
                for i in 0..<stroke.count - 1 {
                    let point = stroke[i]
                    let nextPoint = stroke[i + 1]
                    let dist = sqrt((point.x - nextPoint.x) * (point.x - nextPoint.x) + (point.y - nextPoint.y) * (point.y - nextPoint.y))
                    //                c.setFillColor(red: dist / maxDist, green: 0, blue: 0.5, alpha: 1)
                    c.setFillColor(UIColor(hue: CGFloat(dist / maxDist), saturation: 1, brightness: 1, alpha: 1).cgColor)
                    c.fill(CGRect(x: CGFloat(point.x), y: CGFloat(point.y), width: 5, height: 5))
                }
            }
        }
        
        for object in objects {
            object.draw(onContext: c)
        }
    }
    
    func tryRecognition() throws {
        // TODO have the recognition give scores and return the one with the best score.
        if let letterX = try LetterX.tryToRecognize(from: self.strokes) {
            strokes = []
            self.objects.append(letterX)
        }
        if let letterY = try LetterY.tryToRecognize(from: self.strokes) {
            strokes = []
            self.objects.append(letterY)
        }
        self.setNeedsDisplay()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        squares = []
        currentStroke = []
        print("began")
        super.touchesBegan(touches, with: event)
        //        for touch in touches {
        //            print(touch)
        //            let location = touch.location(in: self)
        //            for square in squares {
        //                if square.contains(location) {
        //                    clickedSquares.append(square)
        //                }
        //            }
        //        }
        guard let touch = touches.first else {
            return
        }
        let location = touch.preciseLocation(in: self)
        currentStroke.append(TimedVector(x:Float(location.x), y:Float(location.y), t:Float(touch.timestamp)))
//        squares.append(Square(at: location))
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        let location = touch.preciseLocation(in: self)
        currentStroke.append(TimedVector(x:Float(location.x), y:Float(location.y), t:Float(touch.timestamp)))
//        squares.append(Square(at: location))
        
//        if clickedSquares.isEmpty {
//            print("Append")
//            for touch in touches {
//                let location = touch.location(in: self)
//                squares.append(Square.init(at: location))
//
//            }
//        }
//        else {
//            print("Drag")
//            let touchesList = Array(touches)
//            for i in 0..<touchesList.count {
//                let location = touchesList[i].location(in: self)
//                clickedSquares[i].setLocation(location: location)
//
//            }
//        }
//
        self.setNeedsDisplay()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touches ended")
//        if clickedSquares.isEmpty {
//            touchesMoved(touches, with: event)
//        }
////        for touch in touches {
////            let location: CGPoint = touch.location(in: self)
////            for square in squares {
////                if square.contains(location) {
////                    square.toggle()
////                }
////            }
////        }
//        self.setNeedsDisplay()
//        clickedSquares = []
//        print(stroke.map({String(format: "%.5f", $0.x)}))
//        print(stroke.map({String(format: "%.5f", $0.y)}))
//        print(stroke.map({String(format: "%.5f", $0.t)}))
//        print(currentStroke.map({$0.x}))
//        print(currentStroke.map({$0.y}))
//        print(currentStroke.map({String(format: "%.10f", $0.t)}))
        
        strokes.append(Stroke(sequence: VectorSequence(vectors: currentStroke)))
        print(strokes[strokes.count - 1].points())
        currentStroke = []
        do {
            try self.tryRecognition()
        } catch {
            print("Recognition failed due to bug")
        }
    }
}
