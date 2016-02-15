//
//  TextContentLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class NHTextLayer: CALayer {
    
    var attributedText: NSAttributedString?
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.setNeedsDisplay()
    }
    override func drawInContext(ctx: CGContext) {
        
        autoreleasepool {
            super.drawInContext(ctx)
            
            guard let attributedText = self.attributedText else { return }
            let bounds = self.bounds
            CGContextSetTextMatrix(ctx, CGAffineTransformIdentity)
            CGContextTranslateCTM(ctx, bounds.minX, bounds.maxY)
            CGContextScaleCTM(ctx, 1, -1)
            
            let path = CGPathCreateMutable()
            CGPathAddRect(path, nil, bounds)
            let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
            let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
            CTFrameDraw(frame, ctx)
        }
    }
}

class TextContentLayer: CALayer {
    
    private(set) var textLayer: NHTextLayer!
    
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
        self.textLayer = NHTextLayer()
        self.textLayer.contentsScale = UIScreen.mainScreen().scale
        self.addSublayer(self.textLayer)
        
        self.textLayer.actions = ["contents": NSNull()]
        
        //        self.shouldRasterize = true
        //        self.rasterizationScale = UIScreen.mainScreen().scale
        //        self.drawsAsynchronously = true
        
        //        self.textLayer.shouldRasterize = true
        //        self.textLayer.rasterizationScale = UIScreen.mainScreen().scale
                self.textLayer.drawsAsynchronously = true
    }
    
    override func layoutSublayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        super.layoutSublayers()
        
        self.textLayer.frame = UIEdgeInsetsInsetRect(self.bounds, self.textInsets)
        CATransaction.commit()
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
//        let font = UIFont.systemFontOfSize(16)

//        let cgFont = font.fontName
//        contentLayer.textLayer.font = cgFont
//        contentLayer.textLayer.fontSize = font.pointSize
//        
//        contentLayer.textLayer.foregroundColor = UIColor.darkGrayColor().CGColor
//        contentLayer.textLayer.wrapped = true
//        contentLayer.textLayer.alignmentMode = kCAAlignmentLeft
        contentLayer.textLayer.contentsScale = UIScreen.mainScreen().scale
    }
    
    class func setupSize(text: String?) -> CGSize {
        guard let text = text else { return .zero }
//        let font = UIFont.systemFontOfSize(12)
//        let str = text as NSString
//        let attr = [
//            NSFontAttributeName : font
//        ]
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.maximumLineHeight = 21
        paragraphStyle.minimumLineHeight = 21
//        paragraphStyle.lineSpacing = 0
        
        let r = NSAttributedString(string: text ?? "", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSParagraphStyleAttributeName : paragraphStyle
            ]).boundingRectWithSize(CGSizeMake(215, CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context:nil)
        
//        str.boundingRectWithSize(CGSizeMake(215, CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes:attr, context:nil)
        
        var size = r.size
        size.height = max(size.height, 15)
        size.width = max(size.width, 10)
        
        size.height += 19
        size.width += 18
        
        return size
    }
}
