//
//  OutgoingCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

//class OutgoingCell: MaskedCell<TextMessageLayer> {
class OutgoingTextCell: TextCell, DeliveredCheckProtocol {
    
    // MARK: - Property
    
    var deliveredCheck = CALayer()
    
    override class var maskImage: UIImage? {
        return UIImage(named: "rightBubbleBackground")
    }
    
    override class var maskInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 0)
    }
    
    override class var textInsets: UIEdgeInsets {
         return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 15)
    }
    
    override class var bubbleImage: UIImage? {
        return UIImage(named: "right_bubble_min")
    }
    
    override class var messageAnchor: CGPoint {
        return CGPoint(x: 1, y: 0.5)
    }
    
    override class var contentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3.5, bottom: 9, right: 3)
    }
    
    // MARK: - Setup
    
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
        self.setupDeliveredCheck()
    }
    
    private func setupMessageLayer() {
        self.messageLayer.contentLayer.backgroundColor = UIColor.blueColor().CGColor
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.deliveredCheck.frame = CGRect(
            x: self.bounds.width - (self.messageLayer.bounds.width + 23),
            y: self.bounds.height - 25,
            width: 11, height: 11)
        
        self.messageLayer.position = CGPoint(x: self.bounds.width - 10, y: self.bounds.height / 2)
        self.messageLayer.setNeedsLayout()
        self.messageLayer.layoutIfNeeded()
        
        super.layoutSubviews()
        CATransaction.commit()
    }
    
    // нужно для норального отображения эмоджиков?
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
            NSParagraphStyleAttributeName : paragraphStyle,
            NSForegroundColorAttributeName: UIColor.whiteColor()
            ])
        
        var size = TextMessageLayer.setupSize(text)
        size.width += 10
        self.messageLayer.frame.size = size
    }
    
    // MARK: - Delivered check
    
    func setupDeliveredCheck() {

        self.setupDeliveredCheck(deliveredCheck)
        self.layer.addSublayer(deliveredCheck)

    }
    
}