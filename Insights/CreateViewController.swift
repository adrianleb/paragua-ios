//
//  CreateViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 27/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {

    let ref = Firebase(url: "https://insights.firebaseio.com/insights")
    var locationManager = LocationManager.sharedInstance
    
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var LocationString: UILabel!
    
    @IBAction func postButtonTouched(sender: AnyObject) {
        let geoFire = GeoFire(firebaseRef: self.ref)
        let lat = self.locationManager.latitude
        let lon = self.locationManager.longitude
        
        let timeStamp = NSDate().timeIntervalSince1970
        let uid = SessionManager.sharedInstance.authData?.uid
        if uid != nil {
            println("lets do this")
            var insight = Dictionary<String, AnyObject>()
            let text = self.contentField.text
            insight["body"] = text
            insight["user_id"] = uid
            insight["created_at"] = timeStamp
            insight["upvotes"] = []
            var insightRef = self.ref.childByAutoId()
            geoFire.setLocation(CLLocation(latitude: lat, longitude: lon), forKey: insightRef.key)
            insightRef.updateChildValues(insight)
            self.performSegueWithIdentifier("goBackToInsights", sender: self)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let lat = self.locationManager.latitude
        let lon = self.locationManager.longitude
        self.contentField.delegate = self

        self.locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: lat, longitude: lon, onReverseGeocodingCompletionHandler: {(reverseGeocodeInfo, placemark, error) in
            let place = placemark!
            self.LocationString.text = place.description
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
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
