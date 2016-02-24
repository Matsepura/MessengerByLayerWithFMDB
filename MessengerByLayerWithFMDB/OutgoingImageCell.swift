//
//  OutgoingCell_Image.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class OutgoingImageCell: MaskedCell {

    // MARK: Property
    
    override class var maskImage: UIImage? {
        return UIImage(named: "rightBubbleBackground")
    }
    
    override class var maskInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 0)
    }
    
    override class var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3.5, bottom: 9, right: 3.5)
    }
    
    override class var bubbleImage: UIImage? {
        return UIImage(named: "right_bubble_min")
    }
    
    override class var messageAnchor: CGPoint {
        return CGPoint(x: 1, y: 0.5)
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
        setupMessageLayer()
    }
    
    private func setupMessageLayer() {
        
        self.messageLayer.contentLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        self.messageLayer.contentLayer.contentsGravity = kCAGravityResizeAspectFill
        self.messageLayer.frame.size = calculateSizeOfBubbleImage()
        
        self.messageLayer.contentLayer.contents = UIImage(named: "cat")?.CGImage

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.messageLayer.position = CGPoint(x: self.bounds.width - 10, y: self.bounds.height / 2)
    }
    
    func calculateSizeOfBubbleImage() -> CGSize {
        var size = CGSize()
        size = CGSizeMake(120, 120)
        return size
    }

}