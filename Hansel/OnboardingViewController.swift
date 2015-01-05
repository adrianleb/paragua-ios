//
//  OnboardingViewController.swift
//  Hansel
//
//  Created by Adrian le Bas on 04/01/15.
//  Copyright (c) 2015 Adrian le Bas. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var accessTapped: UIButton!
    
    @IBAction func accessTapped(sender: AnyObject) {
        LocationManager.sharedInstance.requestPermission()
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "userCold")
        self.performSegueWithIdentifier("unwindToMainFromOnboarding", sender: self)
        
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
