//
//  MapViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 26/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBAction func rangeSliderChanged(sender: UISlider) {
        var currentValue = sender.value
        InsightsManager.sharedInstance.setRange(sender.value)
        self.rangeLabel.text = "\(currentValue)m"
        self.drawRadiusAndPositionAndInsights()
    }
    
    var location: CLLocation?
    var locationManager = LocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.Map.delegate = self
        
        self.locationManager.autoUpdate = true
        self.locationManager.startUpdatingLocation()
        

        self.rangeSlider.continuous = false
        self.rangeSlider.value = Float(InsightsManager.sharedInstance.range)
        self.rangeLabel.text = "\(Float(InsightsManager.sharedInstance.range))m"
        drawRadiusAndPositionAndInsights()
        
        

        
        
 

        
        

        // Do any additional setup after loading the view.
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
        if InsightsManager.sharedInstance.insights.count == 0 {
            InsightsManager.sharedInstance.queryRegion()
        } else {
            for insight in InsightsManager.sharedInstance.insights {
                println(insight)
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
