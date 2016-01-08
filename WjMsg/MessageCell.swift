//
//  MessageCell.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-17.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import Foundation
import UIKit



class MessageCell:UITableViewCell {

//     @IBOutlet weak var senderAndTimeLabel:UILabel!
//     @IBOutlet weak var messageContentView:UITextView!
//     @IBOutlet weak var bgImageView:UIImageView!
    
    
    var textRect: CGRect?
//    var senderAndTimeLabel:UILabel  = UILabel()
//    var messageContentView:UITextView  = UITextView()
//    var bgImageView:UIImageView  = UIImageView()
    
    var senderAndTimeLabel:UILabel?
    var messageContentView:UITextView?
    var bgImageView:UIImageView?
//    init() {
//       
//    }
//    init(newStyle:UITableViewCellStyle, newReuseIdentifier:NSString) {
//        
//        senderAndTimeLabel = UILabel( frame:CGRectMake(10, 10, 300, 20))
//        bgImageView = UIImageView(frame:CGRectZero)
//        messageContentView = UITextView()
//        
//        super.init(style:newStyle, reuseIdentifier:newReuseIdentifier as String)
//        //日期标签
//        //居中显示
//        senderAndTimeLabel.textAlignment = .Center
//        senderAndTimeLabel.font = UIFont.systemFontOfSize(12.0)
//        //文字颜色
//        senderAndTimeLabel.textColor = UIColor.lightGrayColor()
//        contentView.addSubview(senderAndTimeLabel)
//        
//        //背景图
//        contentView.addSubview(bgImageView)
//        
//        //聊天信息
//        messageContentView.backgroundColor = UIColor.clearColor()
//        //不可编辑
//        messageContentView.editable = false;
//        messageContentView.scrollEnabled = false;
//        messageContentView.sizeToFit()
//        contentView.addSubview(messageContentView)
//        
//    }


    override func layoutSubviews() {
        super.layoutSubviews()
    }
//    required init?(coder aDecoder: NSCoder) {
//        //fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder )
//    }

//    override func drawRect(rect: CGRect) {
//        <#code#>
//    }


}