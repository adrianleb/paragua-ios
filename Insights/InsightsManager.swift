//
//  InsightsManager.swift
//  Insights
//
//  Created by Adrian le Bas on 27/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import Foundation


private let _InsightsManagerSharedInstance = InsightsManager()

class InsightsManager  {
    var insights = [Insight]()
    let ref = Firebase(url: "https://insights.firebaseio.com/insights")
    var locationManager = LocationManager.sharedInstance
    var notificationCenter = NSNotificationCenter.defaultCenter()
    var range = 1500.0
    
    class var sharedInstance : InsightsManager {
        return _InsightsManagerSharedInstance
    }
    
    func queryRegion() {
        let geoFire = GeoFire(firebaseRef: self.ref)
        
        let center = CLLocation(latitude: self.locationManager.latitude, longitude: self.locationManager.longitude)
        
        // Query location by region
        

        var radius = MKCoordinateRegionMakeWithDistance(center.coordinate, self.range, self.range)

        
        var regionQuery = geoFire.queryWithRegion(radius)
        
        var queryHandle = regionQuery.observeEventType(GFEventTypeKeyEntered, withBlock: { (key: String!, location: CLLocation!) in
            println("Key '\(key)' entered the search area and is at location '\(location)'")
            self.addRow(key)
            
            
        })
        
        var queryReadyHandle = regionQuery.observeReadyWithBlock({
            println("Keyssss")
            
        })

    }
    
    func emptyInsights() {
        self.ref.removeAllObservers()
        self.insights.removeAll(keepCapacity: false)
        self.queryRegion()
        
    }
    func setRange(rangeValue: Float) {
        self.range = Double(rangeValue)
        self.emptyInsights()
    }
    
    func addRow(keyString: String) {
        let insightRef = self.ref.childByAppendingPath(keyString)
        println(keyString)
        let insightKey = keyString
        insightRef.observeEventType(.Value, withBlock: { snapshot in
            //            println()
            
            if snapshot.value != nil {
                var bodytext = snapshot.value["body"] as String
                var userId = snapshot.value["user_id"] as String
                var timestamp = snapshot.value["created_at"] as NSTimeInterval
                var coord = snapshot.childSnapshotForPath("l")
                var lat = coord.value[0] as Double?
                var lon = coord.value[1] as Double?
                let results = self.insights.filter { el in el.key == keyString }
                if results.count > 0 {
                    println("already ewists \(results)")
                    // any matching items are in results
                } else {
                    // not found
                    var newInsight = Insight(key: insightKey, body: bodytext, created_at: timestamp,  user_id: userId, upvotes: 0, latitude: lat!, longitude: lon!, distance:0)
                    self.updateInsightDistance(&newInsight)
                    self.insights.append(newInsight)
                    self.filterList()
                    insightRef.removeAllObservers()
                }
            }
            
        }, withCancelBlock: { error in
                println(error.description)
        })
    }
    
    func updateInsightDistance(inout insight:Insight) {
        let insightLocation = CLLocation( latitude: insight.latitude, longitude: insight.longitude)
        let center = CLLocation(latitude: self.locationManager.latitude, longitude: self.locationManager.longitude)
        insight.distance = center.distanceFromLocation(insightLocation)
    }
    
    func filterList() { // should probably be called sort and not filter
        self.insights.sort() {
            return $0.distance < $1.distance
        }
        self.notificationCenter.postNotificationName("newInsight", object: self)
    }
}
