//
//  MainViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 29/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var mainBlur: UIVisualEffectView!
    @IBOutlet weak var overallBlur: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Map: MKMapView!
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func unwindToMainFromFilter(sender: UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    var insights = [Insight]()
    let ref = Firebase(url: "https://insights.firebaseio.com/insights")
    var locationManager = LocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.Map.delegate = self
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        
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
        

        //        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.locationManager.showVerboseMessage = true
        self.locationManager.autoUpdate = true
        self.locationManager.startUpdatingLocation()
        var token : dispatch_once_t = 0
        self.locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            dispatch_once(&token) {
                InsightsManager.sharedInstance.queryRegion()
                InsightsManager.sharedInstance.notificationCenter.addObserver(self, selector: Selector("refreshTables"), name: "newInsight", object:nil)
                self.initWithLocation()

            }
        }
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initWithLocation() {
        self.drawRadiusAndPositionAndInsights()
    }
    
    
    
    func refreshTables() {
        self.drawRadiusAndPositionAndInsights()
        self.tableView.reloadData()
    }
    
    
    
    func drawRadiusAndPositionAndInsights(){
        self.Map.removeOverlays(self.Map.overlays)
        self.Map.removeAnnotations(self.Map.annotations)
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = self.currentCenter().coordinate
        objectAnnotation.title = "You"
        self.Map.addAnnotation(objectAnnotation)
        var circle = MKCircle(centerCoordinate: self.currentCenter().coordinate, radius: InsightsManager.sharedInstance.range as CLLocationDistance)
        var radius = MKCoordinateRegionMakeWithDistance(self.currentCenter().coordinate, InsightsManager.sharedInstance.range*4, InsightsManager.sharedInstance.range*4)
        self.Map.setRegion(radius, animated: true)
        self.Map.addOverlay(circle)
        self.addInsights()
    }
    
    func currentCenter()->CLLocation{
        return CLLocation(latitude: self.locationManager.latitude, longitude: self.locationManager.longitude)
    }
    
    func addInsights(){
        if InsightsManager.sharedInstance.insights.count > 0 {
            for insight in InsightsManager.sharedInstance.insights {
                var objectAnnotation = MKPointAnnotation()
                let center = CLLocation(latitude: insight.latitude, longitude: insight.longitude)
                objectAnnotation.coordinate = center.coordinate
                objectAnnotation.title = insight.body
                self.Map.addAnnotation(objectAnnotation)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.6)
            circle.fillColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return InsightsManager.sharedInstance.insights.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as InsightTableViewCell
        let insight = InsightsManager.sharedInstance.insights[indexPath.row]
        cell.insight = insight
//        cell.BodyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
//        cell.BodyLabel.attributedText = NSAttributedString(string: insight.body)
        cell.BodyLabel.text = insight.body
        cell.DateLabel.text = insight.readableDate()
        cell.UpvoteButton.setTitle("\(insight.upvotes.count)", forState: .Normal)
        cell.DistanceLabel.text = insight.readableDistance()
//        cell.contentView.sizeToFit()
        return cell
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as UIViewController
        //        toViewController.transitioningDelegate = self.transitionManager
        
        if segue.identifier == "detailSegue" {
            
            let rowIndex = self.tableView.indexPathForSelectedRow()
            
            (segue.destinationViewController as DetailViewController).rowIndex = rowIndex?.row
            
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }


}
