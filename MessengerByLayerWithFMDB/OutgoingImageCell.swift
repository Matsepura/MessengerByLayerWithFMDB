//
//  OutgoingCell_Image.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class OutgoingImageCell: MaskedCell, DeliveredCheckProtocol {
    
    // MARK: - Property
    
    var backgroundTimeLayer = CALayer()
    
    var deliveredCheck = CALayer()
    
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
    
    // MARK: - Setup
    
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
        self.setupBackgroundTimeLayer()
        self.setupDeliveredCheck()
    }
    
    private func setupMessageLayer() {
        
        self.messageLayer.contentLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        self.messageLayer.contentLayer.contentsGravity = kCAGravityResizeAspectFill
        self.messageLayer.frame.size = calculateSizeOfBubbleImage()
        
        self.messageLayer.contentLayer.contents = UIImage(named: "cat")?.CGImage

    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
//        self.deliveredCheck.frame = CGRect(
//            x: self.bounds.width - (self.messageLayer.bounds.width + 23),
//            y: self.bounds.height - 25,
//            width: 11, height: 11)
        
        self.messageLayer.position = CGPoint(x: self.bounds.width - 10, y: self.bounds.height / 2)
        self.messageLayer.setNeedsLayout()
        self.messageLayer.layoutIfNeeded()
        
        self.backgroundTimeLayer.anchorPoint = CGPoint(x: 1, y: 1)
        self.backgroundTimeLayer.position = CGPoint(
            x: self.messageLayer.bounds.width - 22,
            y: self.messageLayer.bounds.height - 14)
        
        self.deliveredCheck.anchorPoint = CGPoint(x: 1, y: 1)
        self.deliveredCheck.position = CGPoint(
            x: self.messageLayer.bounds.width - 27,
            y: self.messageLayer.bounds.height - 20)
        
        super.layoutSubviews()
        CATransaction.commit()
    }
    
    func calculateSizeOfBubbleImage() -> CGSize {
        guard let image = UIImage(named: "cat") else { return CGSize(width: 120, height: 120) }
        let size = image.size
        let resultSize: CGSize
        let ratio = size.width / size.height
        let height = 220 / ratio
        
        resultSize = CGSizeMake(220, height)
        return resultSize
    }
    
    // MARK: - Delivered check
    
    func setupDeliveredCheck() {
        
        self.setupDeliveredCheck(deliveredCheck)
        self.messageLayer.addSublayer(deliveredCheck)
        
    }
    
    func setupBackgroundTimeLayer() {
        
        self.backgroundTimeLayer.frame.size = CGSize(width: 60, height: 20)
        self.backgroundTimeLayer.backgroundColor = UIColor.blackColor().CGColor
        self.backgroundTimeLayer.cornerRadius = 10
        self.messageLayer.contentLayer.addSublayer(backgroundTimeLayer)
        
    }

}