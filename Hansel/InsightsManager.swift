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
    let locationManager = LocationManager.sharedInstance
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var range = 1500.0
    let geoFire : GeoFire
    var userDefaults: NSUserDefaults
    var currentSortingIndex = 0
    
    init() {
        self.geoFire = GeoFire(firebaseRef: self.ref)
        self.userDefaults = NSUserDefaults(suiteName: "group.a-le-bas.TodayExtensionSharingDefaults")!
        
        self.userDefaults.setObject(self.insights.description, forKey: "value")
        userDefaults.synchronize()
    }
    
    class var sharedInstance : InsightsManager {
        return _InsightsManagerSharedInstance
    }
    
    func queryRegion() {
//        let geoFire = GeoFire(firebaseRef: self.ref)
        let center = CLLocation(latitude: self.locationManager.latitude, longitude: self.locationManager.longitude)
        let radius = MKCoordinateRegionMakeWithDistance(center.coordinate, self.range, self.range)
        let regionQuery = geoFire.queryWithRegion(radius)
        let queryHandle = regionQuery.observeEventType(GFEventTypeKeyEntered, withBlock: { (key: String!, location: CLLocation!) in
//            println("Key '\(key)' entered the search area and is at location '\(location)'")
            self.addRow(key)
        })
    }
    
    func createNew(data: Dictionary<String, AnyObject>) {
      let lat = self.locationManager.latitude
      let lon = self.locationManager.longitude
      let timestamp = NSDate().timeIntervalSince1970
      let uid = SessionManager.sharedInstance.authData?.uid
      var data = data
      data["user_id"] = uid
      data["created_at"] = timestamp
      let insightRef = self.ref.childByAutoId()
      geoFire.setLocation(CLLocation(latitude: lat, longitude: lon), forKey: insightRef.key)
      insightRef.updateChildValues(data)
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
            let results = self.insights.filter { el in el.key == keyString }
            if results.count == 0 {
                if snapshot.value != nil {
                    var newInsight = Insight(key:keyString, snapshot:snapshot)
                    self.insights.append(newInsight)
                    self.filterList()
                    insightRef.removeAllObservers()
                }
            }
        })
    }
    

    
    func sortBy(index:Int) {
        if index != self.currentSortingIndex {
            self.currentSortingIndex = index
            self.insights.sort() {
              switch index {
                case 0:
                    return $0.rating() > $1.rating()
                case 1:
                    return $0.created_at > $1.created_at
                case 2:
                    return $0.distance() < $1.distance()
                case 3:
                    return $0.upvotes.count > $1.upvotes.count
                default:
                    return $0.rating() > $1.rating()
                }  //Switch
            }
            self.notificationCenter.postNotificationName("newInsight", object: self)
            

        }
        
    }
    func filterList() { // should probably be called sort and not filter
        self.insights.sort() {
            return $0.rating() > $1.rating()
        }
        self.notificationCenter.postNotificationName("newInsight", object: self)
        userDefaults.setObject("yo", forKey: "msg")
        userDefaults.synchronize()
        
    }
}
