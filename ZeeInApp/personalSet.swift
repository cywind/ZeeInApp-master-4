//
//  personalSet.swift
//  ZeeInApp
//
//  Created by 林涵 on 15/5/17.
//  Copyright (c) 2015年 WangJZ. All rights reserved.
//

import UIKit
var personalset : personalSet = personalSet()
struct toset {
    var name = "Un-Named"
    var desc = "Un-Described"
}

class personalSet: NSObject {
    var tosets = [toset]()
    
    func addTask(name: String, desc: String) {
        tosets.append(toset(name: name, desc: desc))
    }
}
