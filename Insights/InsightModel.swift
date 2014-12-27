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
    let upvotes : Int
    let latitude : Double
    let longitude : Double
    var distance : Double?
}