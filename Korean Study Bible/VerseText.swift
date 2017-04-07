//
//  VerseText.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 1/5/17.
//  Copyright © 2017 TItus Cheng. All rights reserved.
//

import Foundation
import UIKit

class VerseText:NSMutableAttributedString {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(string str: String) {
        super.init(string: str, attributes: nil)
        
        let attributes:[String: AnyObject] = [
            NSFontAttributeName: getFont(),
            NSParagraphStyleAttributeName: getParagraph()
        ]
        self.addAttributes(attributes, range: NSMakeRange(0, str.characters.count))
    }
    
    convenience init(index: Int64, string str: String) {
        self.init(string: str)
    }
    
    private func getRaisedIndex() ->  UIFont {
        self.setAttributes([NSFontAttributeName:indexFont!,NSBaselineOffsetAttributeName:5], range: NSRange(location:5,length:self.characters.count))
    }
    
    private func getFont() -> UIFont {
        return UIFont(name:"Arial", size:10.0)!
    }
    
    private func getParagraph() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        return paragraphStyle
    }
    
    
    
    
}
