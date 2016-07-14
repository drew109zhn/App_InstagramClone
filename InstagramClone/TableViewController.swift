//
//  TableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by DrewZhong on 5/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    @IBOutlet weak var navigationbar: UINavigationItem!
    
//    @IBAction func Post(sender: AnyObject) {
//        performSegueWithIdentifier("post", sender: self)
//    }
    
    var user = [""]
    var userID = [""]
    var isfollowing = ["":false]
    
    @IBAction func signout(sender: AnyObject) {
        PFUser.logOut()
        print(PFUser.currentUser())
        self.performSegueWithIdentifier("logout", sender:self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFUser.query()
        var activity = UIActivityIndicatorView(frame:self.view.frame)
        activity.center=self.view.center
        activity.backgroundColor = UIColor(white: 1, alpha: 1)
        activity.hidesWhenStopped=true
        activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.Gray
//        var loadingView: UIView = UIView()
//        loadingView.frame = CGRectMake(0, 0, 80, 80)
//        loadingView.center = self.view.center
//        loadingView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
//        loadingView.clipsToBounds = true
//        loadingView.layer.cornerRadius = 10
//        loadingView.addSubview(activity)
        self.view.addSubview(activity)
        activity.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) in
            if error != nil
            {
                print(error)
            }
            else
            {
                self.user.removeAll()
                self.userID.removeAll()
                self.isfollowing.removeAll()
                if objects?.count>0
                {
                for object in objects as! [PFUser]
                {
                    if object.objectId != PFUser.currentUser()?.objectId
                    {
                        self.user.append(object.username!)
                        self.userID.append(object.objectId!)
                        var query2 = PFQuery(className: "FollowRelation")
                        query2.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
                        query2.whereKey("following", equalTo: object.objectId!)
                        query2.findObjectsInBackgroundWithBlock({ (followers, error) in
                            if error != nil
                            {
                                print(error)
                            }
                            else
                            {
                                if let checkedusers = followers
                                {
                                    if checkedusers.count > 0
                                    {
                                        self.isfollowing[object.objectId!]=true
                                        print(self.isfollowing)
                                    }
                                    else
                                    {
                                        self.isfollowing[object.objectId!]=false
                                    }
                                }
                            }
                                    if self.isfollowing.count == self.userID.count
                                    {
                                        self.tableView.reloadData()
                            }
                        })
                    }
                }
                }
            }
            activity.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        })
        print(isfollowing)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.count
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.09)
//        
//        self.view.addSubview(view)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = user[indexPath.row]
        if isfollowing[userID[indexPath.row]]==true
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if isfollowing[userID[indexPath.row]]==true
        {
            cell?.accessoryType = UITableViewCellAccessoryType.None
            var query2 = PFQuery(className: "FollowRelation")
            query2.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
            query2.whereKey("following", equalTo: userID[indexPath.row])
            query2.findObjectsInBackgroundWithBlock({ (followers, error) in
                if error != nil
                {
                    print(error)
                }
                else
                {
                    if let checkedusers = followers
                    {
                     for checkeduser in checkedusers
                     {
                        checkeduser.deleteInBackground()
                        }
                    }

                }
                self.isfollowing[self.userID[indexPath.row]]=false
                })
        }
        else
        {
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        var object = PFObject(className: "FollowRelation")
        object["follower"]=PFUser.currentUser()?.objectId
        object["following"]=userID[indexPath.row]
        object.saveInBackground()
        isfollowing[userID[indexPath.row]]=true
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
