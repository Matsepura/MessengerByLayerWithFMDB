//
//  IncomingCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class IncomingCell: MaskedCell<TextMessageLayer> {
    
    let bubbleRightCapInsets: UIEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 0)
    let mask = MessageLayer()
    var necessarySize = CGSize()
    
    // MARK: Setup
    
    //    override class func messageLayerClass() -> MessageLayer.Type {
    //        return TextMessageLayer.self
    //    }
    
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
        
        // setup message bubble layer
        self.messageLayer.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.messageLayer.contentInsets = UIEdgeInsets(top: 0, left: 4.5, bottom: 9, right: 3.5)
        self.messageLayer.contentLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        self.messageLayer.contentLayer.textInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 15)
        
        if let bubble = UIImage(named: "rightBubbleBackground") {
            
            self.mask.contentsScale = bubble.scale
            self.mask.contents = bubble.CGImage
            //contentCenter defines stretchable image portion. values from 0 to 1. requires use of points (for iPhone5 - pixel = points / 2.).
            self.mask.contentsCenter = CGRect(x: bubbleRightCapInsets.left/bubble.size.width,
                y: bubbleRightCapInsets.top/bubble.size.height,
                width: 1/bubble.size.width,
                height: 1/bubble.size.height);
        }
        
        if let bubble = UIImage(named: "right_bubble_min") {
            self.messageLayer.contentsScale = bubble.scale
            self.messageLayer.contents = bubble.CGImage
            
            
            //contentCenter defines stretchable image portion. values from 0 to 1. requires use of points (for iPhone5 - pixel = points / 2.).
            self.messageLayer.contentsCenter = CGRect(x: bubbleRightCapInsets.left/bubble.size.width,
                y: bubbleRightCapInsets.top/bubble.size.height,
                width: 1/bubble.size.width,
                height: 1/bubble.size.height);
            
            self.messageLayer.contents = bubble.CGImage
            self.messageLayer.masksToBounds = false
        }

        self.mask.drawsAsynchronously = true
        
        self.messageLayer.contentLayer.mask = self.mask
        self.messageLayer.contentLayer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        super.layoutSubviews()
        
        self.messageLayer.position = CGPoint(x: self.bounds.width - 10, y: self.bounds.height / 2)
        
        self.messageLayer.setNeedsLayout()
        self.messageLayer.layoutIfNeeded()
        self.mask.frame = self.messageLayer.contentLayer.bounds
        CATransaction.commit()
    }
    
    func reload(text: String?) {
        guard text != self.messageLayer.contentLayer.textLayer.string as? String else {
            return
        }
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
//        paragraphStyle.maximumLineHeight = 20
//        paragraphStyle.minimumLineHeight = 20
//        paragraphStyle.lineSpacing = 2
        
        self.messageLayer.contentLayer.textLayer.string = NSAttributedString(string: text ?? "", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSParagraphStyleAttributeName : paragraphStyle
            ])
        var size = TextMessageLayer.setupSize(text)
//        size.height += 10
        size.width += 10
        self.messageLayer.frame.size = size
        
    }
}
