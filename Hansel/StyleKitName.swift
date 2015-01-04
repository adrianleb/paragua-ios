//
//  StyleKitName.swift
//  ProjectName
//
//  Created by AuthorName on 03/01/15.
//  Copyright (c) 2015 CompanyName. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class HanselStyleKit : NSObject {

    //// Drawing Methods

    public class func upArrow() {

        //// Polygon Drawing
        var polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(61, 40))
        polygonPath.addLineToPoint(CGPointMake(64.46, 44.5))
        polygonPath.addLineToPoint(CGPointMake(57.54, 44.5))
        polygonPath.closePath()
        UIColor.grayColor().setFill()
        polygonPath.fill()
    }

}

@objc protocol StyleKitSettableImage {
    func setImage(image: UIImage!)
}

@objc protocol StyleKitSettableSelectedImage {
    func setSelectedImage(image: UIImage!)
}
