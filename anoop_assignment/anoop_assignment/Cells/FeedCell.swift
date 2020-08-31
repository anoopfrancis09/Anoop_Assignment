//
//  FeedCell.swift
//  anoop_assignment
//
//  Created by Apple on 27/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    @IBOutlet weak var profileImageView: InstaImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var feedImageView: InstaImageView!
    

    fileprivate var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                feedImageView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                feedImageView.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func restViewsToDefault() {
        profileImageView.image = nil;
        feedImageView.image = nil
        profileName.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
        restViewsToDefault()
    }

}


extension FeedCell: CellConfigureProtocol {
    func configureCell(config: [String: Any], delegate: NSObject?) {
        guard let feed = config["feed"] as? Feed else {
            restViewsToDefault()
            return
        }
        
        profileName.text = feed.user?.name ?? ""
        
        let aspectRatio = feed.aspectRatio
        
        let constraint = NSLayoutConstraint(item: feedImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: feedImageView, attribute: NSLayoutConstraint.Attribute.height, multiplier: CGFloat(aspectRatio), constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)

        aspectConstraint = constraint
        
        // Setting urls for imageView
        profileImageView.smallImageUrl = feed.user?.profile_image?.small
        profileImageView.mediumImageUrl = feed.user?.profile_image?.medium

        feedImageView.smallImageUrl = feed.urls?.small
        feedImageView.mediumImageUrl = feed.urls?.regular
        let bgColor = feed.color ?? "FFFFF"
        feedImageView?.backgroundColor = UIColor(hexString: "#\(bgColor)")
    }
    
    
}
