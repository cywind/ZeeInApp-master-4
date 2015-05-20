//
//  DataManager.swift
//  ZeeInApp
//
//  Created by WangJZ on 15/4/4.
//  Copyright (c) 2015年 WangJZ. All rights reserved.
//

import Foundation

let dataFilePrefix = "data1"
let dataFileName = "data1.plist"

class DataManager{
    class func LoadData() -> NSMutableArray? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent(dataFileName)
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource(dataFilePrefix, ofType: "plist") {
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
            } else {
                println("\(dataFileName) not found. Please, make sure it is part of the bundle.")
            }
        }
        let resultDictionary = NSMutableArray(contentsOfFile: path)
        println("Loaded \(dataFileName) file is --> \(resultDictionary)")
        return resultDictionary
    }
    
    class func SaveData(data: NSArray?) {
        if let arr = data{
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDirectory = paths.objectAtIndex(0) as! NSString
            let path = documentsDirectory.stringByAppendingPathComponent(dataFileName)
            arr.writeToFile(path, atomically: false)
        }

    }
}
