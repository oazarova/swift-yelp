//
//  BusinessCell.swift
//  Yelp
//
//  Created by Olga Azarova on 2/13/15.
//

import UIKit

class BusinessCell : UITableViewCell {

//    required init(coder aDecoder: NSCoder) {
//        //super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
//    }
    
    weak var business: Business!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        self.imgView.layer.cornerRadius = 3
        self.imgView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setBusiness(business: Business) {
        self.business = business
        if let imageUrl = self.business.imgUrl {
            self.imgView.setImageWithURL(NSURL(string: self.business.imgUrl!))
        } else {
            imgView.image = UIImage(named: "Placeholder")
        }

        self.nameLabel.text = self.business.name
        self.ratingView.setImageWithURL(NSURL(string: self.business.ratingUrl))
        self.ratingLabel.text = String(self.business.numReviews) + " Reviews"
        self.addressLabel.text = self.business.address
        self.distanceLabel.text = String(format: "%.2f mi", self.business.distance)
        self.typeLabel.text = self.business.type
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
    }
    
}