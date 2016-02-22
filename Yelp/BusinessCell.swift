//
//  BusinessCell.swift
//  Yelp
//
//  Created by Pauline on 2/15/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    @IBOutlet weak var contentV: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    // Yelp API doesnt give us much on this pricing but still...
    @IBOutlet weak var pricingLabel: UILabel!
    
    var business: Business!{
        didSet{
            titleLabel.text = business.name
            thumbnailImage.setImageWithURL(business.imageURL!)
            tagLabel.text = business.categories
            addressLabel.text = business.address
            reviewLabel.text = "\(business.reviewCount!) Reviews"
            ratingView.setImageWithURL(business.ratingImageURL!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImage.layer.cornerRadius = 4
        thumbnailImage.clipsToBounds = true
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
