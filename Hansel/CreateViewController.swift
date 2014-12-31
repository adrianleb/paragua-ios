//
//  CreateViewController.swift
//  Insights
//
//  Created by Adrian le Bas on 27/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextViewDelegate {

    let ref = Firebase(url: "https://insights.firebaseio.com/insights")
    var locationManager = LocationManager.sharedInstance
    
    let transitionManager = CreateTransitionManager()
    @IBOutlet weak var contentField: UITextView!
    @IBOutlet weak var LocationString: UILabel!
    
    @IBAction func closeTappend(sender: AnyObject) {
//        performSegueWithIdentifier("unwindToMain", sender: self)
    }
    
    @IBAction func postButtonTouched(sender: AnyObject) {
            println("lets do this")
            var data = Dictionary<String, AnyObject>()
            let text = self.contentField.text
            data["body"] = text
            InsightsManager.sharedInstance.createNew(data)
        
            performSegueWithIdentifier("unwindToMain", sender: self)
//            self.performSegueWithIdentifier("goBackToInsights", sender: self)
            
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.transform = CGAffineTransformMakeTranslation(0,50)
        
        let lat = self.locationManager.latitude
        let lon = self.locationManager.longitude
        self.contentField.delegate = self
        self.transitioningDelegate = self.transitionManager
        
        self.contentField.layer.cornerRadius = 1
//        self.contentField.place
        self.contentField.layer.borderWidth = 1
        self.contentField.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).CGColor
       

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
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        
        let newLength = countElements(textField.text!) + countElements(string!) - range.length
        return newLength <= 10 //Bool
        
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
