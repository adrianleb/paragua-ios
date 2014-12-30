//
//  DetailViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 29/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    var rowIndex: Int?
    var locationManager = LocationManager.sharedInstance
    var insight: Insight?
    
    @IBOutlet weak var bodyText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var Map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.rowIndex)
        if let index = self.rowIndex {
            self.insight = InsightsManager.sharedInstance.insights[self.rowIndex!]
        }
        
        if let insight = self.insight {
            bodyText.text = insight.body
            dateLabel.text = insight.readableDate()
            distanceLabel.text = insight.readableDistance()
            self.Map.delegate = self
            
            var objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = self.currentCenter().coordinate
            objectAnnotation.title = "You"
            self.Map.addAnnotation(objectAnnotation)
            
            let insightPoint = CLLocation(latitude: insight.latitude, longitude: insight.longitude)
            var insightAnnotation = MKPointAnnotation()
            insightAnnotation.coordinate = insightPoint.coordinate
            insightAnnotation.title = "Insight"
            self.Map.addAnnotation(insightAnnotation)
            
            var coordsArray = [self.currentCenter().coordinate, insightPoint.coordinate]
            let polyLine = MKPolyline(coordinates: &coordsArray, count: 2)
            self.Map.addOverlay(polyLine)
            var radius = MKCoordinateRegionMakeWithDistance(self.currentCenter().coordinate, InsightsManager.sharedInstance.range*4, InsightsManager.sharedInstance.range*4)
            self.Map.setRegion(radius, animated: true)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func currentCenter()->CLLocation{
        return CLLocation(latitude: self.locationManager.latitude, longitude: self.locationManager.longitude)
    }
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 1
            return polylineRenderer
        } else {
            return nil
        }
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
