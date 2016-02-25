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
        self.messageLayer.contentLayer.contentsGravity = kCAGravityResizeAspectFill
        self.messageLayer.contentLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        self.messageLayer.frame.size = self.calculateSizeOfBubbleImage()
        
        self.messageLayer.contentLayer.contents = UIImage(named: "raketa")?.CGImage
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.messageLayer.position = CGPoint(x: 10, y: self.bounds.height / 2)
        self.messageLayer.setNeedsLayout()
        self.messageLayer.layoutIfNeeded()
        
        super.layoutSubviews()
        CATransaction.commit()
    }
    
    func calculateSizeOfBubbleImage() -> CGSize {
        guard let image = UIImage(named: "raketa") else { return CGSize(width: 120, height: 120) }
        let size = image.size
        let resultSize: CGSize
        let ratio = size.width / size.height
        let height = 220 / ratio
        
        resultSize = CGSizeMake(220, height)
        return resultSize
    }
}