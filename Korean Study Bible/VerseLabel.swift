//
//  VerseLabel.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/17/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import Foundation
import UIKit

class VerseLabel:UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        self.clipsToBounds = true
        self.textColor = UIColor.white
        self.numberOfLines = 0
    }
}

