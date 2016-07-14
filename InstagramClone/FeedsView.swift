//
//  FeedsView.swift
//  ParseStarterProject-Swift
//
//  Created by DrewZhong on 5/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class FeedsView: UIViewController,UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        view.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.10)
        self.view.addSubview(view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
     
     // Configure the cell...
     
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
