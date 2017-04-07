//
//  BibleAPI.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/14/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import Foundation
import SQLite


class BibleAPI : NSObject {
    
    var db:Connection!
    static let sharedInstance = BibleAPI()
    var selectedBook: BibleBook!
    
    override init() {
        selectedBook = BibleBook(id:"PUzpmu69MQLq85XZCHrm9i", order: 1, name:"Genesis", chapCount: 50)
    }

    
    func connect() throws {
        let path = Bundle.main.path(forResource: "BibleDB", ofType: "sqlite")!
        checkDataBase()
        do {
            db = try Connection(path, readonly: true)
        } catch {
            print("Database is not connected")
        }
    
       // db = try Connection("Documents/BibleDB.db")
    }
    
    func checkDataBase(){
        print("check database...")//log
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = urls[urls.count-1] as NSURL

        let url = path.appendingPathComponent("BibleDB.sqlite")
        // Load the existing database
        if !FileManager.default.fileExists(atPath: url!.path) {
            print("Not found, copy one!!!")//log
            let sourceSqliteURL = Bundle.main.url(forResource: "BibleDB", withExtension: "sqlite")!
            let destSqliteURL = path.appendingPathComponent("BibleDB.sqlite")
            do {
                try FileManager.default.copyItem(at: sourceSqliteURL, to: destSqliteURL!)
            } catch {
                print(error)
            }           
        }else{
            print("DB file exist")//log
        }}
    
    func getAvailableChapters(bookindex: Int64) -> [String] {
        var chapterCount:Int64 = 0
        let sqlstmt = "select count(distinct chapter) from kr_niv_verse where book_id=(select id from kr_niv_book where sequence=\(bookindex))"
        print("[debug] Executing sql: " + sqlstmt)
        do {
            for row in try db.prepare(sqlstmt) {
                print("chapter: \(row[0])")
                chapterCount = row[0] as! Int64

            }
        } catch {
            print("Failed to get available chapters")
        }
        var chapters = [String]()
        for index in 1...(chapterCount + 1) {
            chapters.append("\(index)")
        }
        return chapters
    }
    
    func getDefaultChapter() -> [String] {
        var verses:[String]!
        let sqlstmt = "select content from kr_niv_verse where book_id=(select id from kr_niv_book where book='Genesis') and chapter=1 order by verse asc"
        print("[debug] Executing sql: " + sqlstmt)
        verses = [String]()
        do {
            for row in try db.prepare(sqlstmt) {
                if let verse = row[0] {
                    print("verse: \(verse)")
                    verses.append(verse as! String)
                }
            }
        } catch {
            print("[error] Failed to get available verse")
        }
        return verses
        
    }
    
    func getBooks(lang: String, version: String) -> [BibleBook] {
        var books = [BibleBook]()
        let tablename = "\(lang)_\(version)_book"
        let sqlstmt = "select id, sequence, book, chapters from \(tablename) order by sequence"
        print(sqlstmt)
        do {
            for row in try db.prepare(sqlstmt) {
                let book = BibleBook(id: row[0] as! String, order: row[1] as! Int64, name: row[2] as! String, chapCount: row[3] as! Int64)
                books.append(book)
            }
        } catch {
            print("[error] Failed to get books")
        }
        return books
    }
    
    func getSelectedBookName() -> String {
        return "\(selectedBook.getName()) \(selectedBook.getChapter())"
    }
    
    func getChapter(chapter:Int64, langs:[String], version:String) -> BibleChapter {
        var chapter: BibleChapter!
        if (selectedBook != nil) {
            chapter = BibleChapter(langs: langs, book_id: selectedBook.getID(), chapter: selectedBook.getChapter(), version: "niv")
            for lang in langs {
                let sql = chapter.getSQL(lang: lang, id:selectedBook.getOrder())
                print("[sql] \(sql)")
                var count = 1
                do {
                    for row in try db.prepare(sql) {
                        chapter.addVerse(index: count, lang: lang, verse: row[0] as! String)
                        count += 1
                    }
                } catch {
                    print("[Error] failed to get chapters")
                }
            }
        } else {
            print("Selected book is empty")
        }
        return chapter
    }
    
}
