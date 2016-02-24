//
//  TextCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 24.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class TextCell: MaskedCell {

    override class func messageLayerClass() -> MessageLayer.Type {
        return TextMessageLayer.self
    }
    
    class var textInsets: UIEdgeInsets {
        return UIEdgeInsetsZero
    }

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
    }
    
    private func setupMessageLayer() {
        (self.messageLayer.contentLayer as? TextContentLayer)?.textInsets = self.dynamicType.textInsets
    }
}
