//
//  IncomingCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

//class IncomingCell: MaskedCell<TextMessageLayer> {
class IncomingCell: MaskedCell {

    override class var maskImage: UIImage? {
        return UIImage(named: "leftBubbleBackground")
    }
    
    override class var maskInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 25, bottom: 0, right: 0)
    }
    
    // MARK: Setup
    
    override class func messageLayerClass() -> MessageLayer.Type {
        return TextMessageLayer.self
    }
    
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
        
        (self.messageLayer.contentLayer as? TextContentLayer)?.textInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 5)
        
        if let bubble = UIImage(named: "left_bubble_min") {
            self.messageLayer.contentsScale = bubble.scale
            self.messageLayer.contents = bubble.CGImage
            
            //contentCenter defines stretchable image portion. values from 0 to 1. requires use of points (for iPhone5 - pixel = points / 2.).
            
            let bubbleRightCapInsets = self.dynamicType.maskInsets
            self.messageLayer.contentsCenter = CGRect(x: bubbleRightCapInsets.left/bubble.size.width,
                y: bubbleRightCapInsets.top/bubble.size.height,
                width: 1/bubble.size.width,
                height: 1/bubble.size.height);
            
            self.messageLayer.contents = bubble.CGImage
            self.messageLayer.masksToBounds = false
        }
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
    
    func reload(text: String?) {
        guard text != (self.messageLayer.contentLayer as? TextContentLayer)?.textLayer.attributedText?.string else {
            return
        }
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.maximumLineHeight = 21
        paragraphStyle.minimumLineHeight = 21
//        paragraphStyle.lineSpacing = 0
        
        (self.messageLayer.contentLayer as? TextContentLayer)?.textLayer.attributedText = NSAttributedString(string: text ?? "", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSParagraphStyleAttributeName : paragraphStyle
            ])
        var size = TextMessageLayer.setupSize(text)
        size.width += 10
        self.messageLayer.frame.size = size
    }
}