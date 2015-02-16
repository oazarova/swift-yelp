//
//  Business.swift
//  Yelp
//
//  Created by Olga Azarova on 2/11/15.
//

import UIKit

class Business : NSObject {
    
    var imgUrl: String? = ""
    var name: String = ""
    var numReviews: Int = 0
    var address: String = ""
    var type: String = ""
    var distance: Float = 0
    //var price: UILabel!
    var ratingUrl: String = ""
    
    required init(dictionary: NSDictionary){
        super.init()
        
        self.imgUrl = dictionary["image_url"] as? String
        self.name = dictionary["name"] as String
        self.numReviews = dictionary["review_count"] as Int
        
        var location = dictionary["location"] as NSDictionary
        /*
        var addy = location["address"] as [String]
        var neighborhood = location["neighborhoods"] as [String]
        //var city = location["city"] as String
        if (addy != []) {
            self.address = "\(addy[0])"
            if (neighborhood != []){
                self.address += ", \(neighborhood[0])"
            }
        }
        */
        var display_address = location["display_address"] as [String]
        if (display_address != []) {
            self.address = "\(display_address[0])"
        }
        
        
        if let categories = dictionary["categories"] as? NSArray {
            for category in categories
            {
                if (self.type != "") {
                    self.type += ", "
                }
                self.type += category[0] as String
            }
        }

        let milesPerMeter = 0.000621371 as Float
        if let distanceParam = dictionary["distance"] as? Float {
            self.distance = distanceParam * milesPerMeter
        }

        self.ratingUrl = dictionary["rating_img_url"] as String
    }
    
    class func businessesWithDictionaries(dictionaries: [NSDictionary]) -> NSArray{
        var businesses: NSMutableArray = []
        for dictionary in dictionaries {
            let business = Business(dictionary: dictionary as NSDictionary) as Business
            businesses.addObject(business)
        }
        return businesses
    }
}