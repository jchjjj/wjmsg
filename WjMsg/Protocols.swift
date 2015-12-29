//
//  Protocols.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/29.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import Foundation

protocol ChatDelegate  {
    
    func newBuddyOnline( buddyName: String)
    func buddyWentOffline(buddyNmae : String)
    func didDisconnect()
    
}

protocol MessageDelegate {
    func newMessageReceived( messageContent: Message)
}

