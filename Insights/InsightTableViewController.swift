//
//  InsightTableViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 26/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit
import CoreLocation

class InsightTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var insights = [Insight]()
    let ref = Firebase(url: "https://insights.firebaseio.com/insights")
    var locationManager = LocationManager.sharedInstance
    
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;

        SessionManager.sharedInstance.checkSession({(result: Bool) in
            if result != true {
                self.performSegueWithIdentifier("pushLogin", sender: self)
            } else {
                println("all seems good")
                println(SessionManager.sharedInstance.authData?.uid)
            }
            return
        })

        
//        let geoFire = GeoFire()
        let recognizer2 = TickleGestureRecognizer(target: self, action: Selector("handleTickle:"))
        recognizer2.delegate = self
        view.addGestureRecognizer(recognizer2)
        
        
//        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        self.locationManager.showVerboseMessage = true
        self.locationManager.autoUpdate = true
        self.locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
//          println("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
            if InsightsManager.sharedInstance.insights.count == 0 {
                InsightsManager.sharedInstance.queryRegion()
            }
        }
        InsightsManager.sharedInstance.notificationCenter.addObserver(self, selector: Selector("refreshTables"), name: "newInsight", object:nil)

    }


//    
//    override func didReceiveMemoaryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    func refreshTables() {
        self.tableView.reloadData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return InsightsManager.sharedInstance.insights.count
    }

 
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as InsightTableViewCell
//
//        self.contentView.frame = self.bounds;
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        
        // Get the corresponding candy from our candies array
        var insight = InsightsManager.sharedInstance.insights[indexPath.row]

//        body
//        cell.BodyLabel.preferredMaxLayoutWidth = cell.BodyLabel.frame.size.width - 200
//        cell.BodyLabel.numberOfLines = 0
        cell.BodyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.BodyLabel.attributedText = NSAttributedString(string: insight.body)
//        
//        let maxHeight : CGFloat = 10000
//        let maxWidth : CGFloat = cell.BodyLabel.frame.size.width
//        let rect = cell.BodyLabel.attributedText.boundingRectWithSize(CGSizeMake(maxWidth, maxHeight),
//            options: .UsesLineFragmentOrigin, context: nil)
//        var frame = cell.BodyLabel.frame
//        frame.size.height = rect.size.height + 30
//        cell.BodyLabel.frame = frame
        
//        println(cell.BodyLabel.sizeThatFits(CGSize(width: cell.BodyLabel, height: <#CGFloat#>))
        
//        date
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let date = NSDate(timeIntervalSince1970: insight.created_at)
        
        let dateString = formatter.stringFromDate(date)
        cell.DateLabel.text = dateString
        
        
//        votes
        cell.UpvoteButton.setTitle("\(insight.upvotes)", forState: .Normal)
//        distance
        

        let lengthFormatter = NSLengthFormatter()
        cell.DistanceLabel.text = "\( lengthFormatter.stringFromMeters(insight.distance!))"
        
        
        
        cell.contentView.sizeToFit()
        
        return cell
    }

    
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
