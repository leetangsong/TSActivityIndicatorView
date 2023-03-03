//
//  ViewController.swift
//  TSActivityIndicatorView
//
//  Created by leetangsong on 02/26/2023.
//  Copyright (c) 2023 leetangsong. All rights reserved.
//

import UIKit
import TSActivityIndicatorView
class ViewController: UIViewController {
    @IBOutlet weak var pasume: UIButton!
    
    var indicatorView: TSActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let  indicatorView =  TSActivityIndicatorView.init(frame: CGRect.init(x: 100, y: 200, width: 200, height: 100), type: .lineSpinFadeLoader())
        indicatorView.color = .blue
        view.addSubview(indicatorView)
        indicatorView.startAnimating()
        self.indicatorView = indicatorView
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func change(_ sender: UISlider) {
        indicatorView?.setProgress(progress: CGFloat(sender.value))
    }
    @IBAction func paused(_ sender: Any) {
        indicatorView?.pauseAnimating()
    }
    
    @IBAction func resume(_ sender: Any) {
        indicatorView?.resumeAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

