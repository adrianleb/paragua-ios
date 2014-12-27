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
    var manager: OneShotLocationManager?
    var location: CLLocation?
    let ref = Firebase(url: "https://insights.firebaseio.com/insights")
    var locationManager = LocationManager.sharedInstance
    
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
          println("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
            if self.insights.count == 0 {
                self.queryRegion()
            }
        }
    }
    func queryRegion() {
        let geoFire = GeoFire(firebaseRef: self.ref)
        
        let center = CLLocation(latitude: self.locationManager.latitude, longitude: self.locationManager.longitude)
        
        // Query location by region
        let span = MKCoordinateSpanMake(10.5, 10.5)
        let region = MKCoordinateRegionMake(center.coordinate, span)
        
        var regionQuery = geoFire.queryWithRegion(region)
        
        var queryHandle = regionQuery.observeEventType(GFEventTypeKeyEntered, withBlock: { (key: String!, location: CLLocation!) in
            println("Key '\(key)' entered the search area and is at location '\(location)'")
            self.addRow(key)
            
            
        })
        
        var queryReadyHandle = regionQuery.observeReadyWithBlock({
            println("Keyssss")
//            self.locationManager.stopUpdatingLocation()
            
        })
        
//        // Attach a closure to read the data at our posts reference
//        self.ref.observeEventType(.Value, withBlock: { snapshot in
//            
//            for rest in snapshot.children.allObjects as [FDataSnapshot] {
//                
////                println(rest.value["body"])
//                let newInsight = Insight(body: "lalalala", created_at: "2014-10-10",  user_id: 1, upvotes: 10, latitude: 52.377924, longitude: 4.890417, distance:0)
//                self.insights.append(newInsight)
//            }
//            self.tableView.reloadData()
//            }, withCancelBlock: { error in
//                println(error.description)
//        })
//        
        


        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func addRow(keyString: String) {
        let insightRef = self.ref.childByAppendingPath(keyString)
        println(keyString)
        let insightKey = keyString
        insightRef.observeEventType(.Value, withBlock: { snapshot in
//            println()

            var bodytext = snapshot.value["body"] as String?
            var userId = snapshot.value["user_id"] as String?
            var timestamp = snapshot.value["created_at"] as NSTimeInterval?
            var coord = snapshot.childSnapshotForPath("l")
            var lat = coord.value[0] as Double?
            var lon = coord.value[1] as Double?
            let results = self.insights.filter { el in el.key == keyString }
            if results.count > 0 {
                println("already ewists")
                // any matching items are in results
            } else {
                // not found
                var newInsight = Insight(key: insightKey, body: bodytext!, created_at: timestamp!,  user_id: userId!, upvotes: 0, latitude: lat!, longitude: lon!, distance:0)
                self.updateInsightDistance(&newInsight)
                self.insights.append(newInsight)
                self.filterList()
                insightRef.removeAllObservers()
            }
            
//            let existingInsight = $.find(self.insights) { $0.key == insightKey }
//            println("FOUND--- \(existingInsight)")

            }, withCancelBlock: { error in
                println(error.description)
        })
        
    }
    func filterList() { // should probably be called sort and not filter
        self.insights.sort() {
            return $0.distance < $1.distance
        } // sort the fruit by name
        self.tableView.reloadData(); // notify the table view the data has changed
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
//
//        self.contentView.frame = self.bounds;
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        
        // Get the corresponding candy from our candies array
        var insight = self.insights[indexPath.row]

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

    
    func updateInsightDistance(inout insight:Insight) {
        let insightLocation = CLLocation( latitude: insight.latitude, longitude: insight.longitude)
        let center = CLLocation(latitude: self.locationManager.latitude, longitude: self.locationManager.longitude)
        insight.distance = center.distanceFromLocation(insightLocation)
    }
    
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        manager = OneShotLocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                self.location = location
                for i in 0...self.insights.count-1 {
                    self.updateInsightDistance(&self.insights[i])
                }
                self.tableView.reloadData()

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
