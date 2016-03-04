//
//  TextMessageLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 17.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

// отвечает за подсчет размеров слоя исходя от количества символов в тексте

import UIKit

class TextMessageLayer: MessageLayer {
    
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
    }
    
    class func setupSize(text: String?) -> CGSize {
        guard let text = text else { return .zero }
        
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.maximumLineHeight = 21
        paragraphStyle.minimumLineHeight = 21
        //        paragraphStyle.lineSpacing = 0
        
        let attributedString = NSAttributedString(string: text ?? "", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSParagraphStyleAttributeName : paragraphStyle
            ])
        
        let textRange = CFRangeMake(0, attributedString.length)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let constraints = CGSize(width: 215, height: CGFloat.max)
        let additionalHeight: CGFloat
        
        var size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, nil, constraints, nil)
        
        do {
            
            var rangeToSize = CFRangeMake(0, attributedString.length)
            
            let path = CGPathCreateMutable()
            CGPathAddRect(path, nil, CGRect(origin: .zero, size: constraints))
            let frame = CTFramesetterCreateFrame(framesetter, rangeToSize, path, nil)
            let lines = CTFrameGetLines(frame) as [AnyObject]
            
            if let line = lines.last {
                let visibleLine = line as! CTLine
                let range = CTLineGetStringRange(visibleLine)
                
                rangeToSize = CFRangeMake(range.location, range.length)
            }
            
            let lastLineSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, nil, constraints, nil)
            
            let lastLineWidth = lastLineSize.width
            
            let currentLastLineWidth = lastLineWidth + 50
            
            if currentLastLineWidth > 215 {
                additionalHeight = lastLineSize.height
            } else if currentLastLineWidth > size.width {
                additionalHeight = 0
                size.width = currentLastLineWidth
            } else {
                additionalHeight = 0
            }
        }
        
        size.height += (20 + additionalHeight)
        size.width += 18
        
        return size
    }
}