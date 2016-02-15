//
//  MaskedCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class MaskedCell<T: CALayer>: UITableViewCell {
    
    // MARK: Property
    
    private(set) var messageLayer: T!
    
    // MARK: Setup
    
    class func messageLayerClass() -> MessageLayer.Type {
        return MessageLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier id: String?) {
        super.init(style: style, reuseIdentifier: id)
        
        self.commonInit()
    }
    
    private func commonInit() {
        
        
        self.setupMessageLayer()
    }
    
    private func setupMessageLayer() {
        self.messageLayer = T.init()
        self.contentView.layer.addSublayer(self.messageLayer)
        self.messageLayer.masksToBounds = false
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    
    // MARK: - UIMenuItem
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        return action == "copy:"
    }
    
    override func copy(sender: AnyObject?) {

        print("pop")
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .Began {
            print("Received longPress!")
            self.becomeFirstResponder()
            UIMenuController.sharedMenuController().setTargetRect(self.messageLayer.frame, inView: self)
            UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
        }
    }
}
