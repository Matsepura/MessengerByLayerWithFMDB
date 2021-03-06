//
//  MaskedCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

// кастомный класс ячейки

import UIKit

@objc protocol MaskedCellProtocol {
    optional func maskedCell(cell: UITableViewCell, canPerfomAction action: Selector) -> Bool
    optional func maskedCellDidCopy(cell: UITableViewCell)
}

class MaskedCell: UITableViewCell {
    
    // MARK: Property
    
    var timeLayer = NHTextLayer()
    
    weak var maskedCellDelegate: MaskedCellProtocol?
    
    private(set) var messageLayer: MessageLayer!
    private(set) var messageLayerMask: CALayer!
    
    private var longGestureRecognizer: UILongPressGestureRecognizer!
    
    class var maskImage: UIImage? {
        return nil
    }
    
    class var maskInsets: UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    class var bubbleImage: UIImage? {
        return nil
    }
    
    class var messageAnchor: CGPoint {
        return CGPoint(x: 0.5, y: 0.5)
    }
    
    class var contentInsets: UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    // MARK: - Setup
    
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
        self.messageLayer.anchorPoint = self.dynamicType.messageAnchor
        self.messageLayer.contentInsets = self.dynamicType.contentInsets
        
        //mask init
        self.setupMask()
        self.setupBubble()
        
        self.longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        self.longGestureRecognizer?.delegate = self
        self.addGestureRecognizer(self.longGestureRecognizer)
        
        self.setupTimeLayer()


    }
    
    private func setupMask() {
        self.messageLayerMask = CALayer()
        self.messageLayerMask.drawsAsynchronously = true
        if let maskImage = self.dynamicType.maskImage {
            let maskInsets = self.dynamicType.maskInsets
            
            self.messageLayerMask.contentsScale = maskImage.scale
            self.messageLayerMask.contents = maskImage.CGImage
            //contentCenter defines stretchable image portion. values from 0 to 1. requires use of points (for iPhone5 - pixel = points / 2.).
            self.messageLayerMask.contentsCenter = CGRect(x: maskInsets.left/maskImage.size.width,
                y: maskInsets.top/maskImage.size.height,
                width: 1/maskImage.size.width,
                height: 1/maskImage.size.height);
            
            self.messageLayer.contentLayer.mask = self.messageLayerMask
            self.messageLayer.contentLayer.masksToBounds = true
        }
    }
    
    private func setupBubble() {
        if let bubble = self.dynamicType.bubbleImage {
            self.messageLayer.contentsScale = bubble.scale
            self.messageLayer.contents = bubble.CGImage
            
            let bubbleRightCapInsets = self.dynamicType.maskInsets
            
            self.messageLayer.contentsCenter = CGRect(x: bubbleRightCapInsets.left/bubble.size.width,
                y: bubbleRightCapInsets.top/bubble.size.height,
                width: 1/bubble.size.width,
                height: 1/bubble.size.height);
            
            self.messageLayer.contents = bubble.CGImage
            self.messageLayer.masksToBounds = false
        }
    }
    
    // MARK: - Time layer
    
    func setupTimeLayer() {
        let string = "13:07"
        var attributedString = NSMutableAttributedString()
//        if self.dynamicType is IncomingTextCell.Type{
            attributedString = NSMutableAttributedString(string: string ?? "00:00" , attributes: [
                NSFontAttributeName : UIFont.systemFontOfSize(12),
                NSForegroundColorAttributeName : UIColor.lightGrayColor()
                ])
//        } else {
//        attributedString = NSMutableAttributedString(string: string ?? "00:00" , attributes: [
//            NSFontAttributeName : UIFont.systemFontOfSize(12),
//            NSForegroundColorAttributeName : UIColor.whiteColor()
//            ])
//        }
        self.timeLayer.attributedText = attributedString
        self.timeLayer.contentsScale = UIScreen.mainScreen().scale
        self.timeLayer.bounds.size = CGSize(width: 50, height: 20)
        self.messageLayer.addSublayer(timeLayer)   
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
    
    // MARK: - LayoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch self.dynamicType {
            
        case is GroupIncomingTextCell.Type:
            self.timeLayer.anchorPoint = CGPoint(x: 1, y: 1)
            self.timeLayer.position = CGPoint(
                x: self.messageLayer.bounds.width + 5,
                y: self.messageLayer.bounds.height - 10)
            
        case is GroupIncomingImageCell.Type:
            self.timeLayer.anchorPoint = CGPoint(x: 1, y: 1)
            self.timeLayer.position = CGPoint(
                x: self.messageLayer.bounds.width + 5,
                y: self.messageLayer.bounds.height - 10)
            
        case is OutgoingTextCell.Type:
            self.timeLayer.anchorPoint = CGPoint(x: 1, y: 1)
            self.timeLayer.position = CGPoint(
                x: self.messageLayer.bounds.width - 15,
                y: self.messageLayer.bounds.height - 10)
            
        case is OutgoingImageCell.Type:
            self.timeLayer.anchorPoint = CGPoint(x: 1, y: 1)
            self.timeLayer.position = CGPoint(
                x: self.messageLayer.bounds.width - 23,
                y: self.messageLayer.bounds.height - 11)
            
        case is IncomingTextCell.Type:
            self.timeLayer.anchorPoint = CGPoint(x: 1, y: 1)
            self.timeLayer.position = CGPoint(
                x: self.messageLayer.bounds.width + 5,
                y: self.messageLayer.bounds.height - 10)
            
        case is IncomingImageCell.Type:
            self.timeLayer.anchorPoint = CGPoint(x: 1, y: 1)
            self.timeLayer.position = CGPoint(
                x: self.messageLayer.bounds.width + 5,
                y: self.messageLayer.bounds.height - 10)
            
        default:
            break
        }
        
        self.messageLayerMask?.frame = self.messageLayer.contentLayer.bounds
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            print("Received longPress!")
            self.becomeFirstResponder()
            UIMenuController.sharedMenuController().setTargetRect(self.messageLayer.frame, inView: self)
            UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
        }
    }
}

// MARK: - Gesture recognizer

extension MaskedCell {
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.longGestureRecognizer {
            let location = gestureRecognizer.locationInView(self)
            let messageFrame = self.messageLayer.frame
            let result = messageFrame.contains(location)
            return result
        }
        
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}