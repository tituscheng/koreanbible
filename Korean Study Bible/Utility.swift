//
//  Utility.swift
//  Korean Study Bible
//
//  Created by TItus Cheng on 10/18/16.
//  Copyright © 2016 TItus Cheng. All rights reserved.
//

import Foundation
import UIKit

class Util:NSObject {

    class func getPath(fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
class func copyFile(fileName: NSString) {
    print("Copying file")
    let dbPath: String = getPath(fileName: fileName as String)
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: dbPath) {
        
        let documentsURL = Bundle.main.resourceURL
        let fromPath = documentsURL!.appendingPathComponent(fileName as String)
        
        var error : NSError?
        do {
            try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
        } catch let error1 as NSError {
            error = error1
        }
        let alert: UIAlertView = UIAlertView()
        if (error != nil) {
            print("Error Occured")
        } else {
            print("Successfully Copy")
            print("Your database copy successfully")
        }
        alert.delegate = nil
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
}
    
    class func invokeAlertMethod(strTitle: NSString, strBody: NSString, delegate: AnyObject?)
    {
        var alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
}
