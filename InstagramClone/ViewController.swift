/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate{
    
    var signup = true;
    
    @IBAction func touchtouch(sender: AnyObject) {
        
        view.endEditing(true)
    }
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var Switch: UIButton!
    @IBOutlet weak var Statement: UILabel!
    @IBOutlet weak var EnterEmail: UITextField!
    @IBOutlet weak var EnterPassword: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func SwitchAction(sender: AnyObject) {
        
        if (signup == true)
        {
            signup = false
            Switch.setTitle("Sign up", forState: UIControlState.Normal)
            submit.setTitle("Log in", forState: UIControlState.Normal)
            Statement.text = "New user?"
            print(signup)
            
        }
        else if signup == false
        {
            signup = true
            Switch.setTitle("Log in", forState: UIControlState.Normal)
            submit.setTitle("Sign up", forState: UIControlState.Normal)
            Statement.text = "Already signed up?"
            print(signup)
        }
    }
    

    
    @available(iOS 8.0, *)
    
    @IBAction func SubmitAction(sender: AnyObject) {
        
        if (EnterEmail.text! == "" || EnterPassword.text! == "")
        {
            let alert = UIAlertController(title: "Failed", message: "email or password cannot be empty", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                alert.dismissViewControllerAnimated(true, completion: nil)
                }))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        else
        {
         if signup == true
        {
           var user = PFUser()
            user.email=EnterEmail.text!+"@colgate.edu"
            user.username=EnterEmail.text!
            user.password = EnterPassword.text!
            
            var activity = UIActivityIndicatorView(frame:self.view.frame)
            
            activity.center=self.view.center
            activity.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activity.hidesWhenStopped=true
            activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.Gray
            self.view.addSubview(activity)
            activity.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            user.signUpInBackgroundWithBlock({ (sucess, error) in
                activity.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if error == nil{
                    if (sucess)
                    {
                      self.EnterEmail.text="";
                      self.EnterPassword.text="";
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "Failed in Signup", message: String(error!.userInfo["error"]!), preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "try again", style: .Default, handler: { (action) in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            
        }
            else
         {
            var activity = UIActivityIndicatorView(frame:self.view.frame)
            activity.center=self.view.center
            activity.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activity.hidesWhenStopped=true
            activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.Gray
            self.view.addSubview(activity)
            activity.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            PFUser.logInWithUsernameInBackground(EnterEmail.text!, password:EnterPassword.text!, block: { (user, error) in
                
                activity.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error != nil
                {
                    let alert = UIAlertController(title: "Failed login", message: String(error!.userInfo["error"]!), preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: { (action) in
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
               else
                {
                    if user != nil
                    {
                        self.performSegueWithIdentifier("login", sender:self)
                    }
                }
            })
            
         }
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser()?.objectId != nil
        {
            self.performSegueWithIdentifier("login", sender:self)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.endEditing(true);

        
    }

        


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

