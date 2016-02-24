//
//  IncomingCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

//class IncomingCell: MaskedCell<TextMessageLayer> {
class IncomingTextCell: TextCell {

    override class var maskImage: UIImage? {
        return UIImage(named: "leftBubbleBackground")
    }
    
    override class var maskInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 25, bottom: 0, right: 0)
    }
    
    override class var textInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 5)
    }
    
    override class var bubbleImage: UIImage? {
        return UIImage(named: "left_bubble_min")
    }
    
    override class var messageAnchor: CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }
    
    override class var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3.5, bottom: 9, right: 3.5)
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
        self.messageLayer.contentLayer.backgroundColor = UIColor.whiteColor().CGColor
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
//        paragraphStyle.lineSpacing = 0setSelected
        
        (self.messageLayer.contentLayer as? TextContentLayer)?.textLayer.attributedText = NSAttributedString(string: text ?? "", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSParagraphStyleAttributeName : paragraphStyle
            ])
        var size = TextMessageLayer.setupSize(text)
        size.width += 10
        self.messageLayer.frame.size = size
    }
}