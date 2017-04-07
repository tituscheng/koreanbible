//
//  ViewController.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/14/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let bibleDB = BibleAPI.sharedInstance
    var items:BibleChapter!
    var mainNavBar: UINavigationBar!
    var bookButton: UIButton!
    var tableView:UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
           try bibleDB.connect()
        } catch {
           print("Database failed to connect!")
        }
        
        //setup navigation bar
        mainNavBar = UINavigationBar(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:60))
        self.view.addSubview(mainNavBar);
        
        //setup book button
        bookButton = UIButton(type: UIButtonType.roundedRect)
        bookButton.setTitle("창세기", for:UIControlState.normal)
        bookButton.addTarget(self, action: #selector(openBookSelector), for: UIControlEvents.touchUpInside)
        let navItem = UINavigationItem()
        navItem.titleView = bookButton
        mainNavBar.setItems([navItem], animated: false)
        
        //automatic resize
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100


        //setup table view
        let topMargin = CGFloat(10)
        let topY = mainNavBar.frame.size.height + mainNavBar.frame.origin.y + topMargin
        tableView = UITableView()
        tableView.frame = CGRect(x:0, y:topY, width:self.view.frame.width, height:self.view.frame.height - 100 - topMargin)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.openMenu))
        doubleTapGesture.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTapGesture)
        
        tableView.allowsSelection = false
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        items = bibleDB.getChapter(chapter: bibleDB.selectedBook.chapter, langs: ["kr", "en"], version: "niv")
        self.view.addSubview(tableView)
        
    }
    
    func openMenu() {
        print("Should open a menu")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.bibleDB.selectedBook != nil) {
            items = bibleDB.getChapter(chapter: bibleDB.selectedBook.chapter, langs: ["kr", "en"], version: "niv")
            bookButton.setTitle(bibleDB.getSelectedBookName(), for: UIControlState.normal)
            self.tableView.reloadData()
        }
    }
    
    
    func openBookSelector() {
        print("OpenBookSelector called")
        let booklistVC = BookListController()
        self.present(booklistVC, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.getVerseCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let verseLabel = VerseLabel(frame: CGRect(x: 8, y: 8, width: 200, height: 30))
        let verseString = VerseText(index: indexPath.row + 1, string: items.getVerse(index: Int64(indexPath.row)))
        
        //test attributed string
        let indexFont = UIFont(name:"Arial", size:10.0)
        var indexString = NSMutableAttributedString(string: "\(indexPath.row + 1)")
        let indexLength = "\(indexPath.row)".characters.count
//        let verseString = "\(items.getVerse(index: Int64(indexPath.row)))"
//        indexString.setAttributedString(NSFontAttributeName, value:indexFont, range:(NSMakeRange(5, indexLength)))
        let str = NSMutableAttributedString(string: verseString)
        let numLength = "\(indexPath.row + 1)".characters.count
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        str.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, str.length))
        str.addAttribute(NSFontAttributeName, value:indexFont!, range: NSMakeRange(5,numLength))
        str.setAttributes([NSFontAttributeName:indexFont!,NSBaselineOffsetAttributeName:5], range: NSRange(location:5,length:numLength))
        verseLabel.attributedText = verseString
        verseLabel.textColor = UIColor.black
        verseLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(verseLabel)
        
        let leadingMargin = NSLayoutConstraint(item: verseLabel, attribute: NSLayoutAttribute.leadingMargin, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 20)
        let trailingMargin = NSLayoutConstraint(item: verseLabel, attribute: NSLayoutAttribute.trailingMargin, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: -8)
        
        let topMargin = NSLayoutConstraint(item: verseLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        
        let bottomMargin = NSLayoutConstraint(item: verseLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
        
        //  cell.addConstraints([leadingMargin, trailingMargin, topMargin, bottomMargin])
        NSLayoutConstraint.activate([leadingMargin, trailingMargin, topMargin, bottomMargin])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

