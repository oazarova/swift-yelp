//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        //var parameters = ["term": term, "location": "San Francisco"]
        var parameters = ["term": term, "ll" : "37.791412, -122.395606"]
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }

    func searchWithTerm(term: String, params: NSDictionary?, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        var parameters = NSMutableDictionary(dictionary: ["term": term, "ll" : "37.791412, -122.395606"]) //ll represents San Francisco
        
        if let extra = params {
            for (i, j) in extra as [String: AnyObject] {
                switch i {
                    case "category_filter":
                        parameters.setValue(j as String, forKey: i)
                    case "deals_filter":
                        parameters.setValue(j as Bool, forKey: i)
                    default:
                        parameters.setValue(j as String, forKey: i)
                }
            }
        }
        
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
   
    
    func getCommaSeparatedString(arr: [String]) -> String {
        var str : String = ""
        
        for (idx, item) in enumerate(arr) {
            str += "\(item)"
            
            if idx < arr.count - 1 {
                str += ","
            }
        }
        
        return str
    }
    
    func search(term: String, categories: [String], dealsFilter: Bool, radiusFilter: Int, sortByFilter: Int, offset: Int, limit: Int, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        
        var categoriesString = getCommaSeparatedString(categories)
        
        var parameters = ["term": term, "location": "San Francisco", "category_filter" : categoriesString, "deals_filter": dealsFilter, "sort": sortByFilter, "offset": offset, "limit": limit] as NSMutableDictionary
        
        if (radiusFilter > 0) {
            parameters["radius_filter"] = radiusFilter
        }
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
}


