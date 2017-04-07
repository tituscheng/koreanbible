//
//  BibleBook.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/17/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import Foundation

class BibleBook:NSObject {
    var chapter: Int64!
    var startVerse: Int64!
    var endVerse: Int64!
    var order: Int64!
    var chapCount: Int64!
    var name:String!
    var id: String!
    
    init(id: String, order: Int64, name: String, chapCount: Int64) {
        self.name = name
        self.chapter = 1
        self.startVerse = 1
        self.endVerse = 1
        self.order = order
        self.chapCount = chapCount
        self.id = id
    }
    
    
    func setChapter(chapter: Int64) {
        self.chapter = chapter
    }
    
    func setStartVerse(index: Int64) {
        self.startVerse = index
    }
    
    func setEndVerse(index: Int64) {
        self.endVerse = index
    }
    
    func getOrder() -> Int64 {
        return self.order
    }
    
    func getChapter() -> Int64 {
        return self.chapter
    }
    
    func getChapterCount() -> Int64 {
        return self.chapCount
    }
    func getStartVerse() -> Int64 {
        return self.startVerse
    }
    
    func getEndVerse() -> Int64 {
        return self.endVerse
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getID() -> String {
        return self.id
    }
}
