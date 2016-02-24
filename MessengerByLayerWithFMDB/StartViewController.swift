//
//  StartViewController.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 19.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    
    var SingleChatButton: UIButton!
    var GroupChatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        setupButtons()
        self.view.addSubview(SingleChatButton)
        self.view.addSubview(GroupChatButton)
    }
    
    func setupButtons() {
        
        SingleChatButton = UIButton(type: .Custom)
        SingleChatButton.frame.size = CGSize(width: 200, height: 50)
        SingleChatButton.frame = CGRect(x: (self.view.frame.width - self.SingleChatButton.frame.width) / 2, y: self.view.frame.height / 5, width: 200, height: 50)
        SingleChatButton.backgroundColor = UIColor.lightGrayColor()
        SingleChatButton.setTitle("Start Single Chat", forState: .Normal)
        SingleChatButton.addTarget(self, action: "buttonSingleChatAction:", forControlEvents: .TouchUpInside)
        
        GroupChatButton = UIButton(type: .Custom)
        GroupChatButton.frame = CGRect(x: (self.view.frame.width - self.SingleChatButton.frame.width) / 2, y: self.view.frame.height / 3, width: 200, height: 50)
        GroupChatButton.backgroundColor = UIColor.lightGrayColor()
        GroupChatButton.setTitle("Start Group Chat", forState: .Normal)
        GroupChatButton.addTarget(self, action: "buttonGroupChatAction:", forControlEvents: .TouchUpInside)
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