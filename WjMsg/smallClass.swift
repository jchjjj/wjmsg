//
//  smallClass.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/29.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import Foundation

//xmpp message

struct Message{
    var content:String
    var sender:String
    var ctime:String
}

func getCurrentTime() -> String{
    
    let nowUTC:NSDate  = NSDate()
    
    let dateFormatter:NSDateFormatter  = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone.localTimeZone()
    dateFormatter.dateStyle = .MediumStyle
    dateFormatter.timeStyle = .MediumStyle
    
    return dateFormatter.stringFromDate(nowUTC)
    
}