//
//  BookListController.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/14/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import Foundation
import UIKit

class BookListController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChapterListDelegate {
    var bookListTableView:UITableView!
    var bibleDB = BibleAPI.sharedInstance
    var mainNavBar:UINavigationBar!
    var navItem:UINavigationItem!
    var selectSegmentControl: UISegmentedControl!
    var items:[Any]!
    var chapterListView: ChapterListView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            try bibleDB.connect()
        } catch {
            print("Database failed to connect!")
        }
        
        //setup table view
        bookListTableView = UITableView()
        bookListTableView.frame = CGRect(x:0, y:90, width:self.view.frame.width, height:self.view.frame.height - 50)
        bookListTableView.delegate = self
        bookListTableView.dataSource = self
        
        bookListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.items = bibleDB.getBooks(lang: "kr", version: "niv") 
        self.view.addSubview(bookListTableView)
        
        //setup navigation bar
        mainNavBar = UINavigationBar(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:60))
        self.view.addSubview(mainNavBar);
        
        selectSegmentControl = UISegmentedControl(items: ["Book", "Chapter"])
        selectSegmentControl.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: 30)
        selectSegmentControl.addTarget(self, action: #selector(categoryChanged), for: UIControlEvents.valueChanged)
        self.view.addSubview(selectSegmentControl)
        navItem = UINavigationItem()
        navItem.title = "Books"
        mainNavBar.setItems([navItem], animated: false)
        
        self.view.backgroundColor = UIColor.white
        selectSegmentControl.selectedSegmentIndex = 0
    }
    
    func categoryChanged() {
        print("Category changed to \(selectSegmentControl.titleForSegment(at: selectSegmentControl.selectedSegmentIndex))")
        if(selectSegmentControl.selectedSegmentIndex == 1) {
            showChapterListView(chapterCount: self.bibleDB.selectedBook.getChapterCount())
        } else {
            chapterListView.removeFromSuperview()
        }
    }
    
    func showChapterListView(chapterCount: Int64) {
            chapterListView = ChapterListView(frame: self.bookListTableView.frame)
            chapterListView.setBlocks(count: chapterCount)
            chapterListView.mydelegate = self
            self.view.addSubview(chapterListView)
            self.view.bringSubview(toFront: chapterListView)

    }
    
    func didSelectChapter(chapter: Int64) {
        bibleDB.selectedBook.setChapter(chapter: chapter)
        self.dismiss(animated: true, completion: nil)
        print("Selected chapter: \(chapter)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let book = items[indexPath.row] as! BibleBook
        if(selectSegmentControl.selectedSegmentIndex == 0) {
            cell.textLabel?.text = book.getName()
        }
        cell.textLabel?.font = UIFont(name: ".SFUIText-Medium", size: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selected book
        bibleDB.selectedBook = self.items[indexPath.row] as! BibleBook
        
        if(selectSegmentControl.selectedSegmentIndex == 0) {
            selectSegmentControl.selectedSegmentIndex = 1
            self.showChapterListView(chapterCount: bibleDB.selectedBook.getChapterCount())
        }
        navItem.title = bibleDB.selectedBook.getName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
