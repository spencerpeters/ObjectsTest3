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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIGraphicsBeginImageContext(CGSize.init(width: drawImageView.bounds.width, height: drawImageView.bounds.height))
        c = UIGraphicsGetCurrentContext()!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
        print(event as Any)
        
//        UIGraphicsBeginImageContext(CGSize.init(width: drawImageView.bounds.width, height: drawImageView.bounds.height))
//        let c = UIGraphicsGetCurrentContext()!
        
        for touch in touches {
            let location: CGPoint = touch.location(in: drawImageView)
            
            c.beginPath()
//            c.move(to: CGPoint.init(x: 0, y:0))
            c.move(to: location)
            
            c.addLine(to: CGPoint.init(x: 100 + location.x, y: 100 + location.y))
            c.addLine(to: CGPoint.init(x: 100 + location.x, y: 0 + location.y))
            
            c.closePath()
            
            c.setFillColor(UIColor.blue.cgColor)
//            c.setStrokeColor(UIColor.green.cgColor)
            
            c.drawPath(using: CGPathDrawingMode.fill)

        
//            let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
        }
        let image: UIImage? = UIImage(cgImage: c.makeImage()!)
        drawImageView.image = image
    }
}

