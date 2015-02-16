//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var client: YelpClient!
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: NSArray = []
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "ajVv21lKSm3oNavIUQCAEA"
    let yelpConsumerSecret = "5XygL3NVypgNE623gpmdvP3NHEQ"
    let yelpToken = "vMaHnnRwm50Q5Ztkl2scsNwgE4DTy1sE"
    let yelpTokenSecret = "OPFDR3EAP2SWhlvSDDycHqFVYZg"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            let businessArray = response["businesses"] as [NSDictionary]
            self.businesses = Business.businessesWithDictionaries(businessArray)
            self.tableView.reloadData()
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println(error)
        }
  
        // from the lab
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "Yelp"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "filterButtonTapped")
        
        //[self .addObserver(self, forKeyPath: "readBytes", options: NSKeyValueObservingOptions, context:  )]
        
        // from the lab
    }
    
    func filterButtonTapped(){
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("olgaa.BusinessCell") as BusinessCell
        cell.business = self.businesses[indexPath.row] as Business
        cell.setBusiness(cell.business)
        return cell
    }
    
    
    // from the lab
    /*
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "readBytes" {
            
        } else if
        
        else if
        
        switch
    }
    */
    // from the lab
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

