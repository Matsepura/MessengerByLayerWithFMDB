//
//  TextContentLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class TextContentLayer: CALayer {
    
    private(set) var textLayer: CATextLayer!
    
    var textInsets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        
        self.commonInit()
    }
    
    override init() {
        super.init()
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.textLayer = CATextLayer()
        self.addSublayer(self.textLayer)
        
        //        self.shouldRasterize = true
        //        self.rasterizationScale = UIScreen.mainScreen().scale
        //        self.drawsAsynchronously = true
        
        //        self.textLayer.shouldRasterize = true
        //        self.textLayer.rasterizationScale = UIScreen.mainScreen().scale
        //        self.textLayer.drawsAsynchronously = true
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        self.textLayer.frame = UIEdgeInsetsInsetRect(self.bounds, self.textInsets)
    }
}

class TextMessageLayer: BaseMessageLayer<TextContentLayer> {
    
    // MARK: - Property
    
    
    
    // MARK: - Setup
    
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
        
        guard let contentLayer = self.contentLayer else { return }
        let font = UIFont.systemFontOfSize(12)

        let fontName = font.fontName as NSString
        let cgFont = CGFontCreateWithFontName(fontName);
        contentLayer.textLayer.font = cgFont
        contentLayer.textLayer.fontSize = font.pointSize
        
        contentLayer.textLayer.foregroundColor = UIColor.darkGrayColor().CGColor
        contentLayer.textLayer.wrapped = true
        contentLayer.textLayer.alignmentMode = kCAAlignmentLeft
        contentLayer.textLayer.contentsScale = UIScreen.mainScreen().scale
    }
    
    
    class func setupSize(text: String?) -> CGSize {
        guard let text = text else { return .zero }
        let font = UIFont.systemFontOfSize(12)
        let str = text as NSString
        let attr = [
            NSFontAttributeName : font
        ]
        
        let r = str.boundingRectWithSize(CGSizeMake(215, CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes:attr, context:nil)
        
        var size = r.size
        size.height += 19
        size.width += 18
        
        return size
    }
}
