//
//  IncomingCell_Image.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class IncomingImageCell: MaskedCell {

    // MARK: Property
    
    override class var maskImage: UIImage? {
        return UIImage(named: "leftBubbleBackground")
    }
    
    override class var maskInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 25, bottom: 0, right: 0)
    }
    
    override class var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3.5, bottom: 9, right: 4.5)
    }
    
    override class var bubbleImage: UIImage? {
        return UIImage(named: "left_bubble_min")
    }
    
    override class var messageAnchor: CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }
    
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
        self.setupMessageLayer()
    }
    
    private func setupMessageLayer() {
        
//        self.messageLayer.anchorPoint = CGPoint(x: 1, y: 0.5)
//        self.messageLayer.contentInsets = UIEdgeInsets(top: 0, left: 4.5, bottom: 9, right: 3.5)
        self.messageLayer.contentLayer.contentsGravity = kCAGravityResizeAspectFill
        self.messageLayer.contentLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        self.messageLayer.frame.size = self.calculateSizeOfBubbleImage()
        
        self.messageLayer.contentLayer.contents = UIImage(named: "raketa")?.CGImage
        
//        if let bubble = UIImage(named: "right_bubble_min") {
//            self.messageLayer.contentsScale = bubble.scale
//            self.messageLayer.contents = bubble.CGImage
//            
//            let bubbleRightCapInsets = self.dynamicType.maskInsets
//            //contentCenter defines stretchable image portion. values from 0 to 1. requires use of points (for iPhone5 - pixel = points / 2.)
//            self.messageLayer.contentsCenter = CGRect(x: bubbleRightCapInsets.left/bubble.size.width,
//                y: bubbleRightCapInsets.top/bubble.size.height,
//                width: 1/bubble.size.width,
//                height: 1/bubble.size.height);
//            
//            self.messageLayer.contents = bubble.CGImage
//            self.messageLayer.masksToBounds = false
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
                self.messageLayer.position = CGPoint(x: 10, y: self.bounds.height / 2)
//        self.messageLayer.position = CGPoint(x: self.bounds.width - 10, y: self.bounds.height / 2)
    }
    
    func calculateSizeOfBubbleImage() -> CGSize {
        var size = CGSize()
        size = CGSizeMake(120, 120)
        return size
    }
}