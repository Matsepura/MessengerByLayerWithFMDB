//
//  StartViewController.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 19.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    
    var singleChatButton: UIButton!
    var groupChatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightTextColor()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        setupButtons()
        self.view.addSubview(singleChatButton)
        self.view.addSubview(groupChatButton)
    }
    
    func setupButtons() {
        
        singleChatButton = UIButton(type: .Custom)
        singleChatButton.frame.size = CGSize(width: 200, height: 50)
        singleChatButton.frame = CGRect(x: (self.view.frame.width - self.singleChatButton.frame.width) / 2, y: self.view.frame.height / 5, width: 200, height: 50)
        singleChatButton.layer.cornerRadius = 10
        singleChatButton.backgroundColor = UIColor.lightGrayColor()
        singleChatButton.setTitle("Start Single Chat", forState: .Normal)
        singleChatButton.addTarget(self, action: "buttonSingleChatAction:", forControlEvents: .TouchUpInside)
        
        groupChatButton = UIButton(type: .Custom)
        groupChatButton.frame = CGRect(x: (self.view.frame.width - self.singleChatButton.frame.width) / 2, y: self.view.frame.height / 3, width: 200, height: 50)
        groupChatButton.layer.cornerRadius = 10
        groupChatButton.backgroundColor = UIColor.lightGrayColor()
        groupChatButton.setTitle("Start Group Chat", forState: .Normal)
        groupChatButton.addTarget(self, action: "buttonGroupChatAction:", forControlEvents: .TouchUpInside)
    }
    
    func buttonSingleChatAction(sender: UIButton) {
//        NSLog("strat open singleChatAction")
        let vc = ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        NSLog("self.navigationController?.pushViewController(vc, animated: true)")
    }
    
    func buttonGroupChatAction(sender: UIButton) {
        let vc = GroupChatViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}