//
//  postImage.swift
//  ParseStarterProject-Swift
//
//  Created by DrewZhong on 5/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class postImage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var Image: UIImageView!
    
    @IBAction func Post(sender: AnyObject) {
        
        if let imageToPost = Image.image
        {
        var imageData = UIImageJPEGRepresentation(imageToPost, 0.5)
        
        var imageFile = PFFile(name: "image.JPEG", data: imageData!)
        
        var post = PFObject(className: "Post")
        
        
        post["Poster"] = PFUser.currentUser()?.objectId
        post["image"] = imageFile
        var activity = UIActivityIndicatorView(frame:self.view.frame)
            
        activity.center=self.view.center
        activity.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        activity.hidesWhenStopped=true
        activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activity)
        activity.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
        post.saveInBackgroundWithBlock({ (success, error) in
            activity.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if success
            {
                print("success")
                self.Image.image = nil
            }
            else
            {
                print(error)
            }
        })
        }
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        Image.image = image
        
    }
    
    @IBAction func Select(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = false
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0)
        )
        view.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.10)
        
        self.view.addSubview(view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
