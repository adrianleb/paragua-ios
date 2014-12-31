//
//  TodayViewController.swift
//  Hansel Now
//
//  Created by Adrian le Bas on 31/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("updateExtension"), name: NSUserDefaultsDidChangeNotification, object: nil)
        
        let userDefaults = NSUserDefaults(suiteName: "group.a-le-bas.TodayExtensionSharingDefaults")!
        let value: AnyObject! = userDefaults.objectForKey("value")
        var dic: Dictionary = userDefaults.dictionaryRepresentation()
        
        println(value)
        println(userDefaults)
        println(dic.keys.array)
        
        
        
        // Do any additional setup after loading the view from its nib.
    }
    
    func updateExtension() {
        let userDefaults = NSUserDefaults(suiteName: "group.a-le-bas.TodayExtensionSharingDefaults")
        let value: AnyObject! = userDefaults!.objectForKey("value")
        println(value)
        self.label.text = "\(value)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
