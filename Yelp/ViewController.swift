//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {
    var client: YelpClient!
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: NSArray = []
    var searchBar: UISearchBar?
    
    var currentParams: NSDictionary?
    var query: String {
        get {
            if let bar = searchBar {
                return bar.text == "" ? "Restaurants" : bar.text
            } else {
                return "Restaurants"
            }
        }
    }
    
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
        
        searchBar = UISearchBar()
        searchBar!.delegate = self
        searchBar!.text = query
        self.navigationItem.titleView = searchBar
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.

        pullData(query, params: nil)
  
        // from the lab
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "Yelp"
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "filterButtonTapped")
        
        //[self .addObserver(self, forKeyPath: "readBytes", options: NSKeyValueObservingOptions, context:  )]
        
        // from the lab
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "olgaa.FilterSegue" {
            let navController = segue.destinationViewController as UINavigationController
            let filterViewController = navController.topViewController as FiltersViewController
            filterViewController.delegate = self
        }
    }
    
    /*
    func filterButtonTapped(){
        let navController = segue.destinationViewController as UINavigationController
        let filterViewController = navController.topViewController as FiltersViewController
        filterViewController.delegate = self
    }
*/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("olgaa.BusinessCell") as BusinessCell
        cell.business = self.businesses[indexPath.row] as Business
        cell.setBusiness(cell.business)
        return cell
    }
 
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar!.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func filtersViewController(filtersController: FiltersViewController, filters: NSDictionary) {
        currentParams = filters
        pullData(query, params: filters)
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //SVProgressHUD.show()
        pullData(query, params: currentParams)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //SVProgressHUD.show()
        pullData(query, params: currentParams)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullData(query: String, params: NSDictionary?) {
        
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm(query, params: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            let businessArray = response["businesses"] as [NSDictionary]
            self.businesses = Business.businessesWithDictionaries(businessArray)
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                let alert = UIAlertController(title: "Network Error!", message: "Can't pull search results from Yelp", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                var searchBar: UISearchBar?
                self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //client.search(query, categories: <#[String]#>, dealsFilter: <#Bool#>, radiusFilter: <#Int#>, sortByFilter: <#Int#>, offset: <#Int#>, limit: <#Int#>, success: <#(AFHTTPRequestOperation!, AnyObject!) -> Void##(AFHTTPRequestOperation!, AnyObject!) -> Void#>, failure: <#(AFHTTPRequestOperation!, NSError!) -> Void##(AFHTTPRequestOperation!, NSError!) -> Void#>)
        /*
        kYelpClient.searchWithTerm(query, params: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let json = JSON(response)
            
            if let businessesDictionary = json["businesses"].array {
                self.businesses = Business.businessesWithDictionaries(businessesDictionary)
            }
            
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                let alert = UIAlertController(title: "Network Error!", message: "Coudldn't fetch Yelp search results :(", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                var searchBar: UISearchBar?self.presentViewController(alert, animated: true, completion: nil)
        }*/
    }
}

