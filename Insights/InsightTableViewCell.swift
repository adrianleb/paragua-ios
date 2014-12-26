//
//  InsightTableViewCell.swift
//  Insights
//
//  Created by Adrian le Bas on 26/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit

class InsightTableViewCell: UITableViewCell {

    @IBOutlet weak var BodyLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
