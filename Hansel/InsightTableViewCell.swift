//
//  InsightTableViewCell.swift
//  Insights
//
//  Created by Adrian le Bas on 26/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit

class InsightTableViewCell: UITableViewCell {


    var insight: Insight?
    @IBOutlet weak var BodyLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var UpvoteButton: UIButton!
    
    @IBAction func voteButtonTapped(sender: UIButton) {
        insight!.addVote()
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.UpvoteButton.layer.cornerRadius = self.UpvoteButton.frame.size.height/2
        self.UpvoteButton.layer.borderWidth = 1
        self.UpvoteButton.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).CGColor

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    override var bounds : CGRect {
//        didSet {
//            // Fix autolayout constraints broken in Xcode 6 GM + iOS 7.1
//            self.contentView.frame = bounds
//        }
//    }
    
}
