//
//  BibleBook.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/17/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import Foundation

class BibleChapter:NSObject {
    var langs:[String]!
    var version: String!
    var verselist: [BibleVerse]!
    var bookid: String!
    var chapter: Int64
    var startVerse: Int64
    var endVerse: Int64
    
    init(langs: [String], book_id: String, chapter: Int64, version: String!) {
        self.langs = langs
        self.bookid = book_id
        self.chapter = chapter
        self.version = version
        self.startVerse = 1
        self.endVerse = 1
        self.verselist = [BibleVerse]()
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
    
    
    func getChapter() -> Int64 {
        return self.chapter
    }
    
    func addVerse(index: Int, lang: String, verse: String) {
        print("verselist: \(verselist.count), index: \(index)")
        if(verselist.count == (index - 1)) {
            let bibleverse = BibleVerse(lang: lang, verse: verse)
            verselist.append(bibleverse)
        } else {
            let bibleverse = verselist[index-1]
            bibleverse.version[lang] = verse
        }
    }
    
    func getVerseCount() -> Int {
        if(self.verselist == nil) {
            return 0
        } else {
            return self.verselist.count
        }
    }
    
    func getVerse(index: Int64) -> String {
        var verses = [String]()
        if(verselist.count > 0) {
            let verseitem = verselist[Int(index)]
            for lang in verseitem.version.keys {
                verses.append(verseitem.version[lang]!)
            }
        } else {
            print("count: \(verselist.count) index: \(index)")
        }
        return verses.joined(separator:"\n     ")
    }

    
    func getStartVerse() -> Int64 {
        return self.startVerse
    }
    
    func getEndVerse() -> Int64 {
        return self.endVerse
    }
    
    func getBookID() -> String {
        return self.bookid
    }
    

    
    func getSQL(lang: String, id: Int64) -> String {
        if let _version = self.version {
            let tableverse = "\(lang)_\(_version)_verse"
            let tablebook = "\(lang)_\(_version)_book"
            return "select content from \(tableverse) where book_id=(select id from \(tablebook) where sequence=\(id))  and chapter=\(self.getChapter()) order by verse asc"
        }
        return ""
    }
    
}
