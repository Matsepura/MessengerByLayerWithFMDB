//
//  Group_IncomingCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 19.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class Group_IncomingCell: IncomingCell {
    
    // MARK: - Property

    var userPicLayer = CALayer()
    var nickName = TextContentLayer()
    
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
        setup()
    }
    
    func setup() {
//        userPicLayer = CALayer()
//        nickName = TextContentLayer()
        
        userPicLayerSetup()
    }

    func userPicLayerSetup() {
        self.userPicLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        if let bubble = UIImage(named: "userpic-big") {
            self.userPicLayer.contentsScale = bubble.scale
            self.userPicLayer.contents = bubble.CGImage
            
            //contentCenter defines stretchable image portion. values from 0 to 1. requires use of points (for iPhone5 - pixel = points / 2.).
            
            let bubbleRightCapInsets = self.dynamicType.maskInsets
            self.userPicLayer.contentsCenter = CGRect(x: bubbleRightCapInsets.left/bubble.size.width,
                y: bubbleRightCapInsets.top/bubble.size.height,
                width: 1/bubble.size.width,
                height: 1/bubble.size.height)
            
            self.userPicLayer.contents = bubble.CGImage
            self.userPicLayer.masksToBounds = false
        }
//        self.messageLayer.addSublayer(userPicLayer)
        self.contentView.layer.addSublayer(userPicLayer)

    }
    
    override func reload(text: String?) {
        guard text != (self.messageLayer.contentLayer as? TextContentLayer)?.textLayer.attributedText?.string else {
            return
        }
        
        let textPlusNickName = "NickName:\n" + text!
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.maximumLineHeight = 21
        paragraphStyle.minimumLineHeight = 21
        //        paragraphStyle.lineSpacing = 0setSelected
        
        (self.messageLayer.contentLayer as? TextContentLayer)?.textLayer.attributedText = NSAttributedString(string: textPlusNickName ?? "", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSParagraphStyleAttributeName : paragraphStyle
            ])
        var size = TextMessageLayer.setupSize(textPlusNickName)
        size.width += 10
        self.messageLayer.frame.size = size
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.userPicLayer.frame.size = CGSize(width: 30, height: 30)
        
        super.layoutSubviews()
        self.messageLayer.position = CGPoint(x: 35, y: self.bounds.height / 2)
        self.userPicLayer.position = CGPoint(x: 5, y: self.messageLayer.bounds.height - 22)
        
        CATransaction.commit()
    }

}
