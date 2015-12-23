//
//  Contact.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/23.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import Foundation


class Contact {
    
    init(name: String, phone: String, address: String, id : String, photoPath: String){
        self.name = name
        self.phone = phone
        self.address = address
        self.id = id
        self.photoPath = photoPath
    }
    convenience init(){
        self.init(name: "", phone: "" , address: "", id: "" ,photoPath: "")
    }
    
    var name : String?
    var phone : String?
    var address : String?
    var photoPath : String?
    var id : String?
    
}