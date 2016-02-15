//
//  MaskedCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit


@objc protocol MaskedCellProtocol {
    optional func maskedCell(cell: UITableViewCell, canPerfomAction action: Selector) -> Bool
    optional func maskedCellDidCopy(cell: UITableViewCell)
}

class MaskedCell<T: CALayer>: UITableViewCell {
    
    weak var maskedCellDelegate: MaskedCellProtocol?
    
    // MARK: Property
    
//    var messageLayerClass: CALayer.Type {
//        return CALayer.self
//    }
    
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
        let returnValue = self.maskedCellDelegate?.maskedCell?(self, canPerfomAction: action) ?? false
        return returnValue
    }
    
    override func copy(sender: AnyObject?) {
        self.maskedCellDelegate?.maskedCellDidCopy?(self)
    }
    
    func jhopa(sender: AnyObject?) {
        
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == .Began {
            print("Received longPress!")
            self.becomeFirstResponder()
            UIMenuController.sharedMenuController().menuItems = [UIMenuItem(title: "Жопа", action: "jhopa:")]
            UIMenuController.sharedMenuController().setTargetRect(self.messageLayer.frame, inView: self)
            UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
        }
    }
}