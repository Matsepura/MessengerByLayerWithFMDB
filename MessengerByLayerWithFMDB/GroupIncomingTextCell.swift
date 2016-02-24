//
//  Group_IncomingCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 19.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class GroupIncomingTextCell: IncomingTextCell {
    
    var avatarButton = UIButton(type: .Custom)
    
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
        self.userPicLayerSetup()
    }

    func userPicLayerSetup() {
        self.avatarButton.layer.masksToBounds = true
        self.avatarButton.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.avatarButton.setImage(UIImage(named: "userpic-big"), forState: .Normal)
        
        self.contentView.addSubview(self.avatarButton)
    }
    
    override func reload(text: String?) {
        guard text != (self.messageLayer.contentLayer as? TextContentLayer)?.textLayer.attributedText?.string else {
            return
        }
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.maximumLineHeight = 21
        paragraphStyle.minimumLineHeight = 21

        //TODO: добавить цвет -
        let nickName = "NickName:\n"
        let attrNickName = NSMutableAttributedString(
            string: nickName,
            attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16),
                NSForegroundColorAttributeName: UIColor.blueColor()])
        
        let textPlusNickName = attrNickName.string + text!
        
        let attributedString = NSMutableAttributedString(string: textPlusNickName ?? "", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSParagraphStyleAttributeName : paragraphStyle,
            ])

        attributedString.addAttribute(NSForegroundColorAttributeName,
            value: UIColor.redColor(),
            range:  NSRange(
                location: 0,
                length: nickName.characters.count))
        
        (self.messageLayer.contentLayer as? TextContentLayer)?.textLayer.attributedText = attributedString
//            = NSMutableAttributedString(string: textPlusNickName ?? "", attributes: [
//            NSFontAttributeName : UIFont.systemFontOfSize(16),
//            NSParagraphStyleAttributeName : paragraphStyle,
//            ])
        
        var size = TextMessageLayer.setupSize(textPlusNickName)
        size.width += 10
        self.messageLayer.frame.size = size
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.avatarButton.frame.size = CGSize(width: 30, height: 30)
        self.avatarButton.layer.cornerRadius = 15
        self.avatarButton.center = CGPoint(x: 5, y: self.messageLayer.bounds.height - 22)
        super.layoutSubviews()
        self.messageLayer.position = CGPoint(x: 35, y: self.bounds.height / 2)
        
        CATransaction.commit()
    }

}
