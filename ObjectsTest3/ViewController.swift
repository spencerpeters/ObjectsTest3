//
//  ViewController.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 12/17/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var drawImageView: UIImageView!
    var c: CGContext!
    var squares: [Square] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIGraphicsBeginImageContext(CGSize.init(width: drawImageView.bounds.width, height: drawImageView.bounds.height))
        c = UIGraphicsGetCurrentContext()!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location: CGPoint = touch.location(in: drawImageView)
            var newSquare = true
            for square in squares {
                if square.contains(location) {
                    square.toggle()
                    newSquare = false
                }
            }
            if newSquare {
                squares.append(Square.init(at: location))
            }
        }
        
        for square in squares {
            square.draw(onContext: c)
        }
            
        let image: UIImage? = UIImage(cgImage: c.makeImage()!)
        drawImageView.image = image
    }
}

