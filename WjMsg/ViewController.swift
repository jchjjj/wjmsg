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
//    - (void)registerForKeyboardNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
//    }
//    
//    - (void)keyboardWasShown:(NSNotification *)aNotification {
//    // Called when the keyboard is shown
//    NSDictionary *info = [Notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    _driverSignupScrollView.contentInset = contentInsets;
//    _driverSignupScrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active field is hidden by keyboard, scroll it so it's visible
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    
//    CGPoint activeFieldPoint = CGPointMake(_activeField.frame.origin.x, _activeField.frame.origin.y + _activeField.frame.size.height);
//    if (!CGRectContainsPoint(aRect, activeFieldPoint)) {
//    [_scrollView scrollRectToVisible:_activeField.frame animated:YES];
//    }
//    }
//    
//    - (void)keyboardWillBeHidden:(NSNotification *)aNotification {
//    // Called when the keyboard is hidden
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    _scrollView.contentInset = contentInsets;
//    _scrollView.scrollIndicatorInsets = contentInsets;
//    }
    @IBOutlet weak var inputview : UIView!
    
    //vars
    var inputRect : CGRect?
    var activeTextField : UITextField?
    var contacts = [Contact]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.delegate = self
        passwd.delegate = self
        

        //keboard notification 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboarddidShown:", name: UIKeyboardDidShowNotification, object: nil  )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardwillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        inputRect = inputview.frame //get initial frame
    }
    
    
    
    func keyboarddidShown(notification: NSNotification ) {
        print("keyboard show")
//        let kbinfo = notification.userInfo
//        let kbSize = kbinfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
//        let kbheight = kbSize?.height
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
        
    }
    
    func keyboardwillHide(notification: NSNotification) {
        print("keyboard hide")
//        let kbinfo = notification.userInfo
//        let kbSize = kbinfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
//        let kbheight = kbSize?.height
//        inputRect?.origin.y += kbheight! / 2.0
//        
////        inputview.frame = inputRect!
//        if let rect = self.activeTextField?.frame {
//            var  newRect = rect
//            newRect.origin.y = kbheight! + 20.0
//            self.activeTextField?.frame = newRect
//        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGIN, sender: nil)
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
            NSUserDefaults.standardUserDefaults().setValue(user, forKey: UID )
            NSUserDefaults.standardUserDefaults().setValue(passwd, forKey: PASSWD)
            print("user and password stored in NSUserDefaults.standardUserDefaults()")
            performSegueWithIdentifier(SEGUE_LOGIN, sender:nil)
        } else {
            alert("请输入用户名和密码", msg: "当前用户名或密码为空！请重新输入。")
        }
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

