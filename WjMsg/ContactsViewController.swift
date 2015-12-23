//
//  ContactsViewController.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/23.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView : UITableView!
    
    
    var contacts = [Contact]()
    
    
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
            self.tableView.reloadData()
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
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactCell
        let contact = contacts[indexPath.row]
        cell.nameLbl.text = contact.name!
        cell.photoImagView.image = UIImage(named: contact.photoPath!)
        
        return cell
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
