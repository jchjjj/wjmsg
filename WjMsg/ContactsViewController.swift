//
//  ContactsViewController.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/23.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit
//import XMPPFramework

class ContactsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,
ChatDelegate{

    @IBOutlet weak var tableView : UITableView!
    
    
    var contacts = [Contact]()
//    var onlineUsers = [Contact]()
    var onlineUsers = [String]()
    var chatUserName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //load database async
        let mainDispatchQueue = dispatch_queue_create("background", nil)
        dispatch_async(mainDispatchQueue){
            print("in background!!!!!!")
            self.initDatabase()
            self.loadContacts()
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
        
        let del:AppDelegate = self.appDelegate();
        del.chatDelegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let ologin : String? = defaults.stringForKey(USERID)
        
        
        
        if  ologin != ""  {
            var login:NSString = ologin!
            if (self.appDelegate().connect()) {
                print("show buddy list")
                
            }
            
        }else {
            let alert = UIAlertController()
            alert.title = "提示"
            alert.message = "您还没有设置账号"
//            alert.show
            //alert.addButtonWithTitle("设置")
            //alert.show()
            //设定用户
//            self.Account(self)
            
        }
    }
    //database related funcs
    func initDatabase () {
        
        let filemgr = NSFileManager.defaultManager()
        let dirPath = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let filePath = dirPath[0].URLByAppendingPathComponent(DATABASENAME).path
        print(filePath)
        let databasePath = filePath! as String
        if !filemgr.fileExistsAtPath(filePath! as String ) {
            let Database = FMDatabase(path: databasePath as String)
            if Database == nil{
                print("error: \(Database.lastErrorMessage())")
            }
            if Database.open() {
                let sql_stmt = "create table if not exists contacts ( id integer primary key autoincrement, name text, address text , phone text, photoPath text)"
                if !Database.executeStatements(sql_stmt) {
                    
                    print("create table ... ,error : \(Database.lastErrorMessage())")
                }
                Database.close()
            }else {
                print("error : \(Database.lastErrorMessage())")
            }
        }
        
    }
    
    func loadContacts(){
        let filemgr = NSFileManager.defaultManager()
        let dirPath = filemgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let filePath = dirPath[0].URLByAppendingPathComponent(DATABASENAME).path
        print(filePath)
        let databasePath = filePath! as String
        let contactDb = FMDatabase(path: databasePath as String )
        if  contactDb.open() {
            let querySQL = "select name , address, phone, photoPath from contacts"
            let results : FMResultSet? = contactDb.executeQuery(querySQL, withArgumentsInArray: nil)
            while results!.next() == true {
                let name = results?.stringForColumn("name")
                let  address  = results?.stringForColumn("address")
                let  phone  = results?.stringForColumn("phone")
                let photoPath = results?.stringForColumn("photoPath")
                let contact = Contact(name: name!, phone: phone!, address: address!, id: "", photoPath: photoPath!)
                contacts.append(contact)
            }
            contactDb.close()
            print("contacts has \(contacts.count) people")
        }else{
            print("error : \(contactDb.lastErrorMessage())")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return contacts.count
        return onlineUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactCell
        //let contact = contacts[indexPath.row]
        //cell.nameLbl.text = contact.name!
        cell.nameLbl.text = onlineUsers[indexPath.row]
        //cell.photoImagView.image = UIImage(named: contact.photoPath!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //start a Chat
        chatUserName = onlineUsers[indexPath.row];
        print("Now chatting with \(chatUserName)")
        
        self.performSegueWithIdentifier(SEGUE_SESSION_DETAIL , sender:self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_SESSION_DETAIL {
            let chatvc = segue.destinationViewController as! ChatViewController
            chatvc.chatWithUser = chatUserName
        }
    }
    //XMPP related funcs
    func appDelegate() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func xmppStream() -> XMPPStream {
        return self.appDelegate().xmppStream!
    }
    
    func newBuddyOnline( buddyName: String){
        var i = 0
        for user in onlineUsers{
            if (user == buddyName) {
                break
            }
            i++
        }
        if i == onlineUsers.count{
            onlineUsers.append(buddyName)
            print("add frends \(buddyName)")
            self.tableView.reloadData();
        }

    }
    
    func buddyWentOffline(buddyName : String){
        var i = 0
        for user in onlineUsers{
            if (user == buddyName) {
                onlineUsers.removeAtIndex(i)
                self.tableView.reloadData();
                break
            }
            i++
        }

    }
    
    func didDisconnect(){
        
        
    }
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
