//
//  InsightTableViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 26/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit
import CoreLocation

class InsightTableViewController: UITableViewController {

    var insights = [Insight]()
    var manager: OneShotLocationManager?
    var location: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Sample Data for candyArray
        self.insights = [
            Insight(body: "lalalala", created_at: "2014-10-10", user_id: 1, latitude: 52.377924, longitude: 4.890417),
            Insight(body: "popopop", created_at: "2014-12-10", user_id: 1, latitude: 52.376850, longitude: 4.894773),
            Insight(body: "kaakak", created_at: "2014-01-20", user_id: 2, latitude: 52.376609, longitude: 4.897734),
            Insight(body: "hehehe", created_at: "2014-4-10", user_id: 4, latitude: 52.375485, longitude: 4.890699)]
 
        

        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.insights.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as InsightTableViewCell

        
        
        // Get the corresponding candy from our candies array
        let insight = self.insights[indexPath.row]

//        body
    
        cell.BodyLabel.text = insight.body
        
//        date
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        
        let dateString = formatter.stringFromDate(NSDate(dateString: insight.created_at))
        cell.DateLabel.text = dateString
        

//        distance
        var insightLocation = CLLocation( latitude: insight.latitude, longitude: insight.longitude)?
        if (self.location != nil) {
           let lengthFormatter = NSLengthFormatter()
            
           cell.DistanceLabel.text = "\( lengthFormatter.stringFromMeters(self.location!.distanceFromLocation(insightLocation)))"
        }
        
        
    
        
        return cell
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                self.location = location
//                println(location)
                self.tableView.reloadData()
            } else if let err = error {
                println(err.localizedDescription)
            }
            self.manager = nil
        }
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
