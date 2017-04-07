//
//  ChapterListView.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/17/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import Foundation
import UIKit

protocol ChapterListDelegate:UIScrollViewDelegate {
    func didSelectChapter(chapter: Int64)
}


class ChapterListView:UIScrollView {
    var rowYCoord = 0
    var rowXCoord = 0
    let limitPerRow = 5
    weak var mydelegate: ChapterListDelegate?
    
    func setBlocks(count: Int64) {
        self.backgroundColor = UIColor.gray
        self.contentSize = CGSize(width: self.frame.width, height: 300)
        let square = Int(self.frame.width-60) / limitPerRow
        print(self.isUserInteractionEnabled)
        print("Is scroll enabled \(self.isScrollEnabled)")
        for index in 1...count {
            let box = UILabel(frame: CGRect(x: rowXCoord, y: rowYCoord, width: square-1, height: square-1))
            box.text = "\(index)"
            box.textAlignment = .center
            box.backgroundColor = UIColor.white
            box.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChapterListView.chapterSelect(_:)) )
            tapGesture.numberOfTapsRequired = 1
            box.addGestureRecognizer(tapGesture)
            if((rowXCoord + square)  >= Int(self.frame.width)) {
                box.frame.size.width = CGFloat(square)
                rowYCoord += square
                rowXCoord = 0
            } else {
                rowXCoord += square
            }
            self.addSubview(box)
        }
        
    }
    
    func chapterSelect(_ sender: UITapGestureRecognizer) {
        let theView = sender.view as! UILabel
        if let chapter = theView.text {
            mydelegate?.didSelectChapter(chapter: Int64(chapter)!)
            self.removeFromSuperview()
        }
        print("Tapped \(theView.text)")
    }
}
