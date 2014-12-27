//
//  MapViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 26/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var Map: MKMapView!
    
    var location: CLLocation?
    var locationManager = LocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.autoUpdate = true
        self.locationManager.startUpdatingLocation()
        let center = CLLocation(latitude: self.locationManager.latitude, longitude: self.locationManager.longitude)
        var span = MKCoordinateSpanMake(0.001, 0.001)
        var region = MKCoordinateRegion(center: center.coordinate, span: span)
        
        self.Map.setRegion(region, animated: true)


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
