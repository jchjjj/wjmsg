//
//  ViewController.swift
//  WjMsg
//
//  Created by jiangchuan on 15/12/22.
//  Copyright © 2015年 jiangchuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var user : UITextField!
    @IBOutlet weak var passwd: UITextField!

    @IBOutlet weak var inputview : UIView!
    
    //vars
    var inputRect : CGRect?
    var activeTextField : UITextField?
    var contacts = [Contact]()
    
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.delegate = self
        passwd.delegate = self
        
        //set timer to check if the user login successfully repeatedly
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "checkUserLogin", userInfo: nil, repeats: true)
        
        
        //keboard notification 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboarddidShown:", name: UIKeyboardDidShowNotification, object: nil  )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardwillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func checkUserLogin() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let passeduser = defaults.valueForKey("passedUser")  {
            if let user = defaults.valueForKey(USERID) {
                let u1 = passeduser as! String
                let u2 = user as! String
                if u1 == u2 {
                    timer?.invalidate()
                    self.performSegueWithIdentifier(SEGUE_LOGIN, sender: nil)
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        inputRect = inputview.frame //get initial frame
    }
    
    
    
    func keyboarddidShown(notification: NSNotification ) {
        print("keyboard show")
        let kbinfo = notification.userInfo
        let kbSize = kbinfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
        let kbheight = kbSize?.height
//        inputRect?.origin.y -= kbheight! / 2.0
//        
////        inputview.frame = inputRect!
//        
//        if let rect = self.activeTextField?.frame {
//            var  newRect = rect
//            newRect.origin.y = kbheight! - 20.0
//            self.activeTextField?.frame = newRect
//        }
        
        //[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        inputview.frame.origin.y -= kbheight!/2.0
        
    }
    
    func keyboardwillHide(notification: NSNotification) {
        print("keyboard hide")
        let kbinfo = notification.userInfo
        let kbSize = kbinfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
        let kbheight = kbSize?.height
//        inputRect?.origin.y += kbheight! / 2.0
//        
////        inputview.frame = inputRect!
//        if let rect = self.activeTextField?.frame {
//            var  newRect = rect
//            newRect.origin.y = kbheight! + 20.0
//            self.activeTextField?.frame = newRect
//        }
        inputview.frame.origin.y += kbheight!/2.0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.valueForKey(UID) != nil  && defaults.valueForKey(PASS) != nil
            && defaults.valueForKey(SERVER) != nil {
//
            self.login()
            
        }
    }
    
    func alert(title : String , msg: String ){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func LoginButtonClicked(sender: UIButton) {
        if let user = self.user.text where user != "", let passwd = self.passwd.text  where passwd != ""   {
            print(user)
            print(passwd)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(user, forKey: UID )
            defaults.setValue(passwd, forKey: PASSWD)
            // tmp use
            defaults.setValue(user, forKey: USERID)
            defaults.setValue(passwd, forKey: PASS)
            defaults.setValue("localhost", forKey: SERVER)
            
            print("user and password stored in NSUserDefaults.standardUserDefaults()")
            print("start login........")
            login()
            
            performSegueWithIdentifier(SEGUE_LOGIN, sender:nil)
        } else {
            alert("请输入用户名和密码", msg: "当前用户名或密码为空！请重新输入。")
        }
    }
    func login(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.connect()
    }
//    @IBAction func chatButtonClicked(sender: UIButton) {
//        performSegueWithIdentifier(SEGUE_SESSION, sender: nil)
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        user.resignFirstResponder()
//        passwd.resignFirstResponder()
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 1 {// user name entered
           textField.resignFirstResponder()
            if let passwd =  textField.superview?.viewWithTag(2) as? UITextField {
                passwd.becomeFirstResponder()
            }
            return false
        } else { //passwd entered
            textField.resignFirstResponder()
            self.LoginButtonClicked(UIButton())
            return false
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeTextField = nil
    }
    
}

