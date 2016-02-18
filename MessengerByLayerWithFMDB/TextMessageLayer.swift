//
//  TextMessageLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 17.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class TextMessageLayer: MessageLayer {
    
    // MARK: - Property
    
    // MARK: - Setup
    
    override class func contentLayerClass() -> CALayer.Type {
        return TextContentLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        
        self.commonInit()
    }
    
    required init() {
        super.init()
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.addTextToLayer()
    }
    
    private func addTextToLayer() {
        guard let contentLayer = self.contentLayer as? TextContentLayer else { return }
        contentLayer.textLayer.contentsScale = UIScreen.mainScreen().scale
    }
    
    class func setupSize(text: String?) -> CGSize {
        guard let text = text else { return .zero }
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.maximumLineHeight = 21
        paragraphStyle.minimumLineHeight = 21
        //        paragraphStyle.lineSpacing = 0
        
        let r = NSAttributedString(string: text ?? "", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSParagraphStyleAttributeName : paragraphStyle
            ]).boundingRectWithSize(CGSizeMake(215, CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context:nil)
        
        var size = r.size
        size.height = max(size.height, 15)
        size.width = max(size.width, 10)
        
        size.height += 19
        size.width += 18
        
        return size
    }
}