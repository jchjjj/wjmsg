//
//  ChatViewController.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/25.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var label : UILabel!
    
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var naviBar : UINavigationBar!
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var tableView : UITableView!
    
    var parterner : String?
    
    //xmpp
    var messages = [Message]()
    var chatWithUser = String()
    
    
    
    override func viewDidLoad() {

        self.textField.text  = parterner
        
        setupTableview()
        
        // nav bar title
//        if !chatWithUser.isEmpty {
//            naviBar.backItem?.title = chatWithUser
//            //naviBar.ite
//        }else{
//            naviBar.backItem?.title = "weizhi"
//        }
        
        let del:AppDelegate  = self.appDelegate();
        del.messageDelegate  = self
        
        // keyboard show and hide , change height of tableview
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboarddidShown:", name: UIKeyboardDidShowNotification, object: nil  )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func setupTableview() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        let bgimg = UIImage(named: "background")
        let bgView = UIImageView(image: bgimg)
        bgView.contentMode = .ScaleToFill
        self.tableView.backgroundView = bgView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.naviBar.topItem?.title = chatWithUser
//        self.naviItem.title = chatWithUser
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textField.endEditing(true)
        //self.sendButton(UIButton())
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
        
        let cell:MessageCell  = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! MessageCell  //使用这个方法，不会返回nil的cell！但返回的cell可能是新的，没有初始化的（在这个场景下，没有添加subviews）
        // 不再使用tableView.dequeueReusableCellWithIdentifier，因为那样的话，无法改变cell内各subview的frame，不知为何；（＝＝＝＝可以改变的，需要在MessageCell中重载layoutSubviews()方法 ＝＝＝） 也不应在reusablecell中添加subview ，这样将会导致reusable cell中的元素累积的越来越多，增加整个view的负担
        //let cell : MessageCell = MessageCell() //这种做法也是不对的，每显示一个cell都要新构造一个Messagecell，没有必要，
        if cell.senderAndTimeLabel == nil {
            print(" a new cell!!!")
            cell.senderAndTimeLabel = UILabel(frame: CGRectMake(5, 5, 320, 15))
            cell.messageContentView = UITextView()
            cell.bgImageView = UIImageView()
            cell.contentView.addSubview(cell.senderAndTimeLabel!)
            cell.contentView.addSubview(cell.bgImageView!)
            cell.contentView.addSubview(cell.messageContentView!)
        }

        
        let msg:Message = messages[indexPath.row];
        
        let textSize = CGSize(width: 260.0 ,height: 10000.0)
        
        let font:UIFont  = UIFont.systemFontOfSize(15)
        var rect:CGRect = msg.content.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        //print("Msg rect is \(rect)")
        rect.size.width += (padding)
 
        cell.messageContentView!.attributedText = NSAttributedString(string: msg.content, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)])
        cell.messageContentView!.backgroundColor = UIColor.clearColor()
        cell.accessoryType = .None;
        cell.userInteractionEnabled = false;
        
        var bgImage:UIImage?
        // get the window width
        let windowWidth = self.view.superview!.frame.width
        print(windowWidth)
        //发送消息
        if (msg.sender == "you") {
            //背景图
            bgImage = UIImage(named:"BlueBubble2")!.resizableImageWithCapInsets(UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20))
            
            cell.messageContentView!.frame = CGRectMake(rect.origin.x+padding+padding/2 , rect.origin.y+padding*3, rect.size.width+padding, rect.size.height+padding)
            
            cell.bgImageView!.frame = CGRectMake(cell.messageContentView!.frame.origin.x - padding, cell.messageContentView!.frame.origin.y - padding/2 , rect.size.width + padding*2.5, rect.size.height + padding*2)
            
            //print("imageview's frame is \(cell.bgImageView.frame)")
        }else {
            
            bgImage = UIImage(named:"GreenBubble2")!.resizableImageWithCapInsets(UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20))
            
            cell.messageContentView!.frame  = CGRectMake(windowWidth-8-rect.size.width - padding-rect.origin.x, padding*3+rect.origin.y, rect.size.width+padding, rect.size.height+padding)
            cell.bgImageView!.frame = CGRectMake(cell.messageContentView!.frame.origin.x - padding*1, cell.messageContentView!.frame.origin.y - padding/2, rect.size.width + padding*2.5, rect.size.height + padding*2)
        }
        
        // set cell appearance 
        cell.selectionStyle = .None
        //cell.backgroundColor = UIColor.lightGrayColor()
        cell.separatorInset = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
        cell.bgImageView!.image = bgImage
        cell.senderAndTimeLabel!.text = "\(msg.sender) \(msg.ctime)"
        cell.senderAndTimeLabel!.font = UIFont.systemFontOfSize(12)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let padding:CGFloat = 20.0
        let msg:Message = messages[indexPath.row];
        
        let textSize = CGSize(width: 260.0 ,height: 10000.0)
        let font:UIFont  = UIFont.systemFontOfSize(15)
        var rect:CGRect = msg.content.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        //var size = msg.content.sizeWithAttributes([NSFontAttributeName:font])
        
        rect.size.height += padding*2.5
        //print("in height : rect is \(rect),height is \(rect.height) ")
        let height:CGFloat = rect.size.height < 70 ? 70 : rect.size.height;
        //print("cell heigth is \(height)")
        return height;
    }
    
    func newMessageReceived( msg: Message){
        print("in chat view controller : @@@@@@@@@@@@msg is \(msg)")
        messages.append(msg)
        
        self.tableView.reloadData()
        scrollToEnd()
    }
    
    @IBAction func sendButton(sender : UIButton) {
        
        //本地输入框中的信息
        let message:String = self.textField.text!
        
        if (message != "") {
            
            //XMPPFramework主要是通过KissXML来生成XML文件
            //生成<body>文档
            let body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(message)
            
            //生成XML消息文档
            let mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
            //消息类型
            mes.addAttributeWithName("type",stringValue:"chat")
            //发送给谁
            mes.addAttributeWithName("to" ,stringValue:chatWithUser)
            //print("send to \(chatWithUser)")
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
            scrollToEnd()
            
        }
    }
    
    func scrollToEnd() {
        let row = self.tableView.numberOfRowsInSection(0)-1
        if row < 1 {
            return
        }
        let lastIndexPath = NSIndexPath(forRow: row , inSection: 0)
        
        self.tableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    func keyboarddidShown(notification: NSNotification ) {
        print("keyboard show")
        let kbinfo = notification.userInfo
        let kbSize = kbinfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
        let kbheight = kbSize?.height

        //tableView.frame.size.height -= kbheight!
        self.view.frame.size.height -= kbheight!
        self.tableView.reloadData()
        scrollToEnd()
//        let row = self.tableView.numberOfRowsInSection(0)-1
//        if row < 1 {
//            return
//        }
//        let lastIndexPath = NSIndexPath(forRow: row , inSection: 0)
//        self.tableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: true)
    }
    
//    keyboardDidHide()
    func keyboardDidHide(notification: NSNotification) {
        print("keyboard  hide")
        let kbinfo = notification.userInfo
        let kbSize = kbinfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
        let kbheight = kbSize?.height
        
        //tableView.frame.size.height += kbheight!
        
        self.view.frame.size.height += kbheight!
        self.tableView.reloadData()
        scrollToEnd()
//        //let row = messages.count-1>0 ? messages.count-1 : 0
//        let row = self.tableView.numberOfRowsInSection(0)-1
//        if row < 1 {
//            return
//        }
//        let lastIndexPath = NSIndexPath(forRow: row , inSection: 0)
//
//        self.tableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: true)
    }
    
}
