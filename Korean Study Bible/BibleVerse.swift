//
//  BibleVerse.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/18/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import Foundation

class BibleVerse:NSObject {
    var version: Dictionary<String, String>!
    
    init(lang: String, verse: String) {
        version = Dictionary<String, String>()
        self.version[lang] = verse
    }
    
}
