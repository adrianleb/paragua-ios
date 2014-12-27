//
//  CreateViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 27/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    let ref = Firebase(url: "https://insights.firebaseio.com/insights")
    var locationManager = LocationManager.sharedInstance
    
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var LocationString: UILabel!
    @IBAction func postButtonTouched(sender: AnyObject) {
    }
    @IBAction func createButonPress(sender: UIBarButtonItem) {
        
        let geoFire = GeoFire(firebaseRef: self.ref)
        let lat = self.locationManager.latitude
        let lon = self.locationManager.longitude
        
        
        let timeStamp = NSDate().timeIntervalSince1970
        let uid = SessionManager.sharedInstance.authData?.uid
        if uid != nil {
            println("lets do this")
            var insight = Dictionary<String, AnyObject>()
            
            
            self.locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: lat, longitude: lon, onReverseGeocodingCompletionHandler: {(reverseGeocodeInfo, placemark, error) in
                println("yes \(timeStamp)")
                var place = placemark!
                insight["body"] = "\(place.description)"
                insight["user_id"] = uid
                insight["created_at"] = timeStamp
                insight["upvotes"] = []
                var insightRef = self.ref.childByAutoId()
                geoFire.setLocation(CLLocation(latitude: lat, longitude: lon), forKey: insightRef.key)
                insightRef.updateChildValues(insight)
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
