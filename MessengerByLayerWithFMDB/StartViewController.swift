//
//  StartViewController.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 19.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        setupButton()
        self.view.addSubview(button)
    }
    
    func setupButton() {
        
        button = UIButton(type: .System)
        button.frame = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2, width: 100, height: 50)
        button.backgroundColor = UIColor.darkGrayColor()
        button.setTitle("Start", forState: .Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
    }
    
    func buttonAction(sender: UIButton) {
        let vc = ViewController()
        // открыть без navigation bar
//        self.presentViewController(vc, animated: true, completion: nil)
        // открыть c navigation bar
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    

    

}
