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

//class MaskedCell<T: CALayer>: UITableViewCell {
class BaseMessageTableViewCell: UITableViewCell {

    weak var maskedCellDelegate: MaskedCellProtocol?
    var mask: CALayer!
    
    class var maskImage: UIImage? {
        return nil
    }
    
    class var maskInsets: UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    
    // MARK: Property
    
    private(set) var messageLayer: MessageLayer!
    
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
        self.messageLayer = self.dynamicType.messageLayerClass().init()
        self.contentView.layer.addSublayer(self.messageLayer)
        self.messageLayer.masksToBounds = false
        
        //mask init
        self.setupMask()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        self.addGestureRecognizer(longPressRecognizer)
    }
    
    private func setupMask() {
        self.mask = CALayer()
        self.mask.drawsAsynchronously = true
        if let maskImage = self.dynamicType.maskImage {
            let maskInsets = self.dynamicType.maskInsets
            
            self.mask.contentsScale = maskImage.scale
            self.mask.contents = maskImage.CGImage
            //contentCenter defines stretchable image portion. values from 0 to 1. requires use of points (for iPhone5 - pixel = points / 2.).
            self.mask.contentsCenter = CGRect(x: maskInsets.left/maskImage.size.width,
                y: maskInsets.top/maskImage.size.height,
                width: 1/maskImage.size.width,
                height: 1/maskImage.size.height);
            
            self.messageLayer.contentLayer.mask = self.mask
            self.messageLayer.contentLayer.masksToBounds = true
        }
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mask.frame = self.messageLayer.contentLayer.bounds
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