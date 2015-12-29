//
//  ChatViewController.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/25.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageDelegate {
    
    @IBOutlet weak var label : UILabel!
    
    @IBOutlet weak var naviBar : UINavigationBar!
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var tableView : UITableView!
    
    var parterner : String?
    
    //xmpp
    var messages = [Message]()
    var chatWithUser = String()
    
    
    
    override func viewDidLoad() {

        self.textField.text  = parterner
        let del:AppDelegate  = self.appDelegate();
        del.messageDelegate  = self
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func appDelegate() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let padding:CGFloat = 10.0
        let identifier:String = "msgCell";
        
        var cell:MessageCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? MessageCell
        
        if (cell == nil) {
            cell = MessageCell(newStyle:.Subtitle ,newReuseIdentifier:identifier)
        }
        
        let msg:Message = messages[indexPath.row];
        
        let textSize = CGSize(width: 260.0 ,height: 10000.0)
        
        let font:UIFont  = UIFont.systemFontOfSize(18)
        var rect:CGRect = msg.content.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        rect.size.width += (padding/2)
        
        
        cell!.messageContentView.text = msg.content;
        cell!.accessoryType = .None;
        cell!.userInteractionEnabled = false;
        
        var bgImage:UIImage?
        
        //发送消息
        if (msg.sender == "you") {
            //背景图
            bgImage = UIImage(named:"BlueBubble2")
            bgImage = bgImage!.stretchableImageWithLeftCapWidth(20,topCapHeight:15)
            cell!.messageContentView.frame = CGRectMake(rect.origin.x+padding, rect.origin.y+padding*4, rect.size.width, rect.size.height)
            
            cell!.bgImageView.frame = CGRectMake(cell!.messageContentView.frame.origin.x - padding/2, cell!.messageContentView.frame.origin.y - padding/2 , rect.size.width + padding, rect.size.height + padding)
        }else {
            
            bgImage = UIImage(named:"GreenBubble2")!.stretchableImageWithLeftCapWidth(14, topCapHeight:15)
            
            cell!.messageContentView.frame = CGRectMake(320-rect.size.width - padding-rect.origin.x, padding*4+rect.origin.y, rect.size.width, rect.size.height)
            cell!.bgImageView.frame = CGRectMake(cell!.messageContentView.frame.origin.x - padding/2, cell!.messageContentView.frame.origin.y - padding/2, rect.size.width + padding, rect.size.height + padding)
        }
        
        cell!.bgImageView.image = bgImage;
        cell!.senderAndTimeLabel.text = "\(msg.sender) \(msg.ctime)"
        
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let padding:CGFloat = 20.0
        let msg:Message = messages[indexPath.row];
        
        let textSize = CGSize(width: 260.0 ,height: 10000.0)
        let font:UIFont  = UIFont.systemFontOfSize(18)
        var rect:CGRect = msg.content.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        //var size = msg.content.sizeWithAttributes([NSFontAttributeName:font])
        rect.size.height += padding*2
        
        let height:CGFloat = rect.size.height < 65 ? 65 : rect.size.height;
        
        return height;
    }
    
    func newMessageReceived( msg: Message){
        print("@@@@@@@@@@@@msg is \(msg)")
        messages.append(msg)
        
        self.tableView.reloadData()
        
    }
    
    @IBAction func sendButton(sender : UIButton) {
        
        //本地输入框中的信息
        var message:String = self.textField.text!
        
        if (message != "") {
            
            //XMPPFramework主要是通过KissXML来生成XML文件
            //生成<body>文档
            var body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(message)
            
            //生成XML消息文档
            var mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
            //消息类型
            mes.addAttributeWithName("type",stringValue:"chat")
            //发送给谁
            mes.addAttributeWithName("to" ,stringValue:chatWithUser)
            print("send to \(chatWithUser)")
            //由谁发送
            mes.addAttributeWithName("from" ,stringValue:NSUserDefaults.standardUserDefaults().stringForKey(USERID)! as String)
            //组合
            mes.addChild(body)
            
            //发送消息
            self.appDelegate().sendElement(mes)
            
            self.textField.text = ""
            self.textField.resignFirstResponder()
            
            let msg:Message = Message(content:message,sender:"you",ctime:getCurrentTime())
            
            messages.append(msg)
            print("send msg:\(messages.count)(\(msg.content),\(msg.sender))")
            
            //重新刷新tableView
            self.tableView.reloadData()
        }
    }
    
}
