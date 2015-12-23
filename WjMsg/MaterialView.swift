//
//  MaterialView.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/22.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit

class MaterialView: UIView {


    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 1.0).CGColor
        
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSizeMake(0, 2.0)
        layer.shadowRadius = 5.0
    }

}
