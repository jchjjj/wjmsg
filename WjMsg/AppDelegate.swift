//
//  AppDelegate.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/22.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit

//import XMPPFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
    , XMPPStreamDelegate
{

    var window: UIWindow?
    
    //XMPP related vars
    var xmppStream:XMPPStream?
    var password:String = ""
    var isOpen:Bool = false
    var isLogin = false
    var chatDelegate:ChatDelegate?
    var messageDelegate:MessageDelegate?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //XMPP related funcs
    func setupStream(){
        
        //初始化XMPPStream
        xmppStream = XMPPStream()
        xmppStream!.addDelegate(self,delegateQueue:dispatch_get_main_queue());
        
    }
    
    func goOnline(){
        
        //发送在线状态
        let presence:XMPPPresence = XMPPPresence()
        xmppStream!.sendElement(presence)
        
    }
    
    func goOffline(){
        
        //发送下线状态
        let presence:XMPPPresence = XMPPPresence(type:"unavailable");
        xmppStream!.sendElement(presence)
        
    }
    
    func connect() -> Bool{
        
        self.setupStream()
        print("in connect ")
        //从本地取得用户名，密码和服务器地址
        let defaults:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        
        let userId:String  = defaults.stringForKey(USERID)!
        let pass:String = defaults.stringForKey(PASS)!
        let server:String = defaults.stringForKey(SERVER)!
        
        if (!xmppStream!.isDisconnected()) {
            return true
        }
        
        if (userId == "" || pass == "") {
            return false;
        }
        
        //设置用户
        xmppStream!.myJID = XMPPJID.jidWithString(userId);
        //设置服务器
        xmppStream!.hostName = server;
        //密码
        password = pass;
        
        //连接服务器
        do {
            try xmppStream!.connectWithTimeout(XMPPStreamTimeoutNone)
            
            return true
        } catch {
            print("Something went wrong!")
            return false
        }
        
    }
    
    func disconnect(){
        
        self.goOffline()
        xmppStream!.disconnect()
        
    }
    //XMPPStreamDelegate协议实现
    //连接服务器
    func xmppStreamDidConnect(sender:XMPPStream ){
        print("######xmppStreamDidConnect \(xmppStream!.isConnected())")
        isOpen = true;

        //验证密码
        print("password is \(password)")
        self.goOnline()
        do{
            try xmppStream!.authenticateWithPassword(password)
            //
        }catch {
            print("Something went wrong in authenticate!")
        }
    }
    
    //验证通过
    func xmppStreamDidAuthenticate(sender:XMPPStream ){
        print("xmppStreamDidAuthenticate")
        
        //store the authenticate info in userdefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(defaults.valueForKey(USERID), forKey: "passedUser")
        
        self.isLogin = true
        self.goOnline()
    }
    func xmppStream(sender:XMPPStream , didNotAuthenticate error:DDXMLElement ){
        print(error)
    }
    //收到消息
    func xmppStream(sender:XMPPStream ,didReceiveMessage message:XMPPMessage? ){
        
        
        if message != nil {
            print(message)
            let cont:String = message!.elementForName("body").stringValue()
            let from:String = message!.attributeForName("from").stringValue()
            
            let msg:Message = Message(content:cont,sender:from,ctime:getCurrentTime())
            
            
            //消息委托(这个后面讲)
            messageDelegate?.newMessageReceived(msg)
        }
        
    }
    
    //收到好友状态
    func xmppStream(sender:XMPPStream ,didReceivePresence presence:XMPPPresence ){
        
        print(presence)
        
        //取得好友状态
        let presenceType:NSString = presence.type() //online/offline
        //当前用户
        let userId:NSString  = sender.myJID.user
        //在线用户
        let presenceFromUser:NSString  = presence.from().user
        
        if (!presenceFromUser.isEqualToString(userId as String)) { // not self
            
            //在线状态
            let srv:String = SERVER
            print(presenceType)
            if (presenceType.isEqualToString("available")) {
                
                //用户列表委托
                chatDelegate?.newBuddyOnline("\(presenceFromUser)@\(srv)")
                
            }else if (presenceType.isEqualToString("unavailable")) {
                //用户列表委托
                chatDelegate?.buddyWentOffline("\(presenceFromUser)@\(srv)")
            }
            
        }
        
    }
    func sendElement(mes:DDXMLElement){
        xmppStream!.sendElement(mes)
    }
    

}

