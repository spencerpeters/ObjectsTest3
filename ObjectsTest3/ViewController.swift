//
//  ViewController.swift
//  ObjectsTest3
//
//  Created by Spencer Peters on 12/17/22.
//

import UIKit

class ViewController: UIViewController {
    
    var spencerView: SpencerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spencerView = SpencerView(frame: self.view.bounds)
        self.view.addSubview(spencerView)
        self.spencerView.isMultipleTouchEnabled = true
    }
}

