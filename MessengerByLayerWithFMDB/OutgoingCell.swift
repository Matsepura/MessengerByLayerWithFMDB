//
//  OutgoingCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class OutgoingCell: MaskedCell<TextMessageLayer> {
    
    let bubbleRightCapInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 25, bottom: 0, right: 0)
    let mask = CALayer()
    
    // MARK: Setup
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    private func commonInit() {
        setupMessagesLayer()
    }
    
    private func setupMessagesLayer() {
        self.messageLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        self.messageLayer.contentInsets = UIEdgeInsets(top: 0, left: 3.5, bottom: 9, right: 4.5)
        self.messageLayer.contentLayer.backgroundColor = UIColor.greenColor().CGColor
        
        self.messageLayer.contentLayer.textInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 5)
        
        if let bubble = UIImage(named: "leftBubbleBackground") {
            
            self.mask.contentsScale = bubble.scale
            self.mask.contents = bubble.CGImage
            //contentCenter defines stretchable image portion. values from 0 to 1. requires use of points (for iPhone5 - pixel = points / 2.).
            self.mask.contentsCenter = CGRect(x: bubbleRightCapInsets.left/bubble.size.width,
                y: bubbleRightCapInsets.top/bubble.size.height,
                width: 1/bubble.size.width,
                height: 1/bubble.size.height);
        }
        
        if let bubble = UIImage(named: "left_bubble_min") {
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
        
        self.messageLayer.position = CGPoint(x: 10, y: self.bounds.height / 2)
        self.messageLayer.setNeedsLayout()
        self.messageLayer.layoutIfNeeded()
        self.mask.frame = self.messageLayer.contentLayer.bounds
        CATransaction.commit()
    }
    
    func reload(text: String?) {
        guard text != self.messageLayer.contentLayer.textLayer.string as? String else {
            return
        }
        self.messageLayer.contentLayer.textLayer.string = text
        var size = TextMessageLayer.setupSize(text)
        size.width += 10
        self.messageLayer.frame.size = size
    }
    
}

