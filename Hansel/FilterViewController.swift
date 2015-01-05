//
//  MapViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 26/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit
import MapKit

class FilterViewController: UIViewController, MKMapViewDelegate {
    let transitionManager = FilterTransitionManager()
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBAction func rangeSliderChanged(sender: UISlider) {
        var currentValue = sender.value
        InsightsManager.sharedInstance.setRange(sender.value)
        self.rangeLabel.text = "\(currentValue)m"
//        self.drawRadiusAndPositionAndInsights()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self.transitionManager
//        self.view.transform = CGAffineTransformMakeTranslation(0,-50)
        self.view.transform = CGAffineTransformMakeScale(0.99, 0.99)
//        self.preferredContentSize = CGSizeMake(320,120)
        


        self.rangeSlider.continuous = false
        self.rangeSlider.value = Float(InsightsManager.sharedInstance.range)
        self.rangeLabel.text = "\(Float(InsightsManager.sharedInstance.range))m"
//        drawRadiusAndPositionAndInsights()
        
        

        
        
 

        
        

        // Do any additional setup after loading the view.
    }
//    func drawRadiusAndPositionAndInsights(){
//        self.Map.removeOverlays(self.Map.overlays)
//        self.Map.removeAnnotations(self.Map.annotations)
//        var objectAnnotation = MKPointAnnotation()
//        objectAnnotation.coordinate = self.currentCenter().coordinate
//        objectAnnotation.title = "You"
//        self.Map.addAnnotation(objectAnnotation)
//        var circle = MKCircle(centerCoordinate: self.currentCenter().coordinate, radius: InsightsManager.sharedInstance.range as CLLocationDistance)
//        var radius = MKCoordinateRegionMakeWithDistance(self.currentCenter().coordinate, InsightsManager.sharedInstance.range*4, InsightsManager.sharedInstance.range*4)
//        self.Map.setRegion(radius, animated: true)
//        self.Map.addOverlay(circle)
//        self.addInsights()
//    }
    

    

    
    
    
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
