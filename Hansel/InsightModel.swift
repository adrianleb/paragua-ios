//
//  InsightModel.swift
//  Insights
//
//  Created by Adrian le Bas on 26/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import Foundation

struct Insight {
    let key : String
    let body : String
    let created_at : NSTimeInterval
    let user_id : String
    let latitude : Double
    let longitude : Double
    let ref : Firebase
    var upvotes = Dictionary<String, AnyObject>()

    
    init(key:String, snapshot: FDataSnapshot) {
        
        var snap = snapshot
        let chids = snapshot.children as NSEnumerator
        self.ref = snapshot.ref
        
//        println()
        
        
        self.key = key
        self.body = snapshot.value["body"] as String
        self.user_id = snapshot.value["user_id"] as String
        self.created_at = snapshot.value["created_at"] as NSTimeInterval
        
        let coord = snapshot.childSnapshotForPath("l")
        
        self.latitude = coord.value[0] as Double
        self.longitude = coord.value[1] as Double
//        self.votes = []
        
        
        if snapshot.hasChild("upvotes") {
            self.upvotes = snapshot.value["upvotes"] as Dictionary<String, AnyObject>
            println(self.upvotes.count)
            
        }
        
        self.rating()
     
        
    }
    
    func readableDistance() -> String {
        
        let newDistance = Int(self.distance())
        let lengthFormatter = NSLengthFormatter()
        lengthFormatter.unitStyle = NSFormattingUnitStyle.Long
        
        return "\( lengthFormatter.stringFromMeters(Double(newDistance)))"
        
    }
    
    func readableDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let date = NSDate(timeIntervalSince1970: self.created_at)
        return  self.timeAgoSinceDate(date, numericDates: true)
        
    }
    
    func distance()-> CLLocationDistance {
            let insightLocation = CLLocation( latitude: self.latitude, longitude: self.longitude)
            let center = CLLocation(latitude: LocationManager.sharedInstance.latitude, longitude: LocationManager.sharedInstance.longitude)
            return center.distanceFromLocation(insightLocation)
    }
    func addVote() {
        let user_id = SessionManager.sharedInstance.authData!.uid!
        if self.upvotes.count != 0 {
            let votesRef = self.ref.childByAppendingPath("upvotes")
            
            let vote = ["\(user_id)":true]
            votesRef.setValue(vote)
            
            
        } else {
            let insight = ["upvotes": ["\(user_id)":true]]
            self.ref.updateChildValues(insight)
        }

        
    }

    
    func rating() -> Float {
        
        let timeWeight = -0.01 as Float
        let socialWeight = 1000 as Float
        let distanceWeight = -2 as Float
        var score = 0.0 as Float
        let currentTime = NSDate()
        let date = NSDate(timeIntervalSince1970: self.created_at)
        let timeDifference = Float(currentTime.timeIntervalSinceDate(date))
//        println( "-------------------------------------")
        score = score + (timeDifference * timeWeight)
//        println( "time: \(timeDifference * timeWeight)")
        score = score + (Float(self.upvotes.count) * socialWeight)
//        println( "social: \(Float(self.upvotes.count) * socialWeight)")
        score = score + (Float(self.distance()) * distanceWeight)
//        println( "time: \(Float(self.distance()) * distanceWeight)")
//        println( "total: \(score)")
//        println( "~~~~~~~~~~=============================================")
        return Float(score)
    }
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitSecond
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: nil)
        
        if (components.year >= 2) {
            return "\(components.year) years ago"
        } else if (components.year >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month >= 2) {
            return "\(components.month) months ago"
        } else if (components.month >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) weeks ago"
        } else if (components.weekOfYear >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day >= 2) {
            return "\(components.day) days ago"
        } else if (components.day >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) hours ago"
        } else if (components.hour >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) minutes ago"
        } else if (components.minute >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second >= 3) {
            return "\(components.second) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    
    
}