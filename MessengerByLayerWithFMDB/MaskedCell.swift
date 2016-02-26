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
        self.messageLayer.anchorPoint = self.dynamicType.messageAnchor
        self.messageLayer.contentInsets = self.dynamicType.contentInsets
        
        //mask init
        self.setupMask()
        self.setupBubble()
        
        self.longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        self.longGestureRecognizer?.delegate = self
        self.addGestureRecognizer(self.longGestureRecognizer)
        
        setupTimeLayer()
        self.layer.addSublayer(timeLayer)
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
        let attributedString = NSMutableAttributedString(string: string ?? "00:00" , attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(11),
            NSForegroundColorAttributeName : UIColor.whiteColor()
            ])
        self.timeLayer.attributedText = attributedString      
        self.timeLayer.contentsScale = UIScreen.mainScreen().scale
        print(self.dynamicType)
        
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(self.dynamicType.description())
        
        switch self.dynamicType.description() {
        case "MessengerByLayerWithFMDB.OutgoingTextCell":
            self.timeLayer.frame = CGRect(
                x: self.bounds.width - (self.messageLayer.bounds.width + 45),
                y: self.bounds.height - 27 ,
                width: 50, height: 50)
            print("case let i where i === OutgoingTextCell:")
            
        case "MessengerByLayerWithFMDB.OutgoingImageCell":
            self.timeLayer.frame = CGRect(
                x: self.bounds.width - (self.messageLayer.bounds.width + 45),
                y: self.bounds.height - 27 ,
                width: 50, height: 50)
            print("case let i where i === OutgoingTextCell:")
            
        case "MessengerByLayerWithFMDB.IncomingTextCell":
            self.timeLayer.frame = CGRect(
                x: self.messageLayer.bounds.width + 15,
                y: self.bounds.height - 27 ,
                width: 50, height: 50)
            print("MessengerByLayerWithFMDB.IncomingTextCell")
            
        case "MessengerByLayerWithFMDB.IncomingImageCell":
            self.timeLayer.frame = CGRect(
                x: self.messageLayer.bounds.width + 15,
                y: self.bounds.height - 27 ,
                width: 50, height: 50)
            print("MessengerByLayerWithFMDB.IncomingImageCell")
            
        case "MessengerByLayerWithFMDB.GroupIncomingTextCell":
            self.timeLayer.frame = CGRect(
                x: self.messageLayer.bounds.width + 38,
                y: self.bounds.height - 32 ,
                width: 50, height: 50)
            print("MessengerByLayerWithFMDB.GroupIncomingTextCell")
            
        case "MessengerByLayerWithFMDB.GroupIncomingImageCell":
            self.timeLayer.frame = CGRect(
                x: self.messageLayer.bounds.width + 38,
                y: self.bounds.height - 27 ,
                width: 50, height: 50)
            print("MessengerByLayerWithFMDB.GroupIncomingTextCell")
            
            
        default:
            self.timeLayer.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
            print("default")
        }
        
        self.messageLayerMask?.frame = self.messageLayer.contentLayer.bounds
        //        self.timeLayer.frame = CGRect(x: self.bounds.width - (self.messageLayer.bounds.width + 50), y: self.bounds.height - 28 , width: 50, height: 50)
        
        print(self.timeLayer.frame)
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

//MARK: - Gesture recognizer
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