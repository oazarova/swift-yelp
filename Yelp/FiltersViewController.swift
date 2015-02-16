//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Olga Azarova on 2/15/15.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SortCellDelegate, DistanceCellDelegate, DealCellDelegate {

    var delegate: FiltersViewControllerDelegate?

    let allSections = ["Offers Deals", "Sort By", "Distance", "Categories"]
    let dealText = "Offers Deals"
    let sortText = "Sort By"
    let distanceText = "Distance"
    let categoryText = "Categories"
    let seeAllText = "See All"
    let collapseText = "Collapse"
    let numPreviewCategories = 4
    
    var selectedCategories = NSMutableSet()
    var filterByDeals = false
    var distance : Float = 12.0
    var selectedSort = 0
    
    let allSorts = ["Best Match", "Distance", "Highest Rated"]
    
    // Filter properties
    var categories : [[String : String]]?
    var categoriesExpanded = false
    // Filters dictionary
    var filters: NSDictionary {
        get {
            let filters =  NSMutableDictionary()
            
            if selectedCategories.count > 0 {
                var names: [String] = []
                for category in selectedCategories {
                    names.append((category as [String: String])["code"]!)
                }
                
                filters.setValue(",".join(names), forKey: "category_filter")
            }
            
            filters.setValue(filterByDeals, forKey: "deals_filter")
            //filters.setValue(Int(distance) * 1609, forKey: "radius_filter")
            filters.setValue(String(selectedSort), forKey: "sort")
            
            return filters
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    required init(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
        categories = getCategories()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButtonPressed")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: UIBarButtonItemStyle.Plain, target: self, action: "applyButtonPressed")
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = allSections as NSArray
        
        switch section {
            case sections.indexOfObject(categoryText):
                return categoriesExpanded ? categories!.count + 1 : numPreviewCategories
            case sections.indexOfObject(sortText):
                return 3
            case sections.indexOfObject(dealText):
                return 1
            case sections.indexOfObject(distanceText):
                return 1
            default:
                return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return allSections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allSections[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sections = allSections as NSArray
        
        switch indexPath.section {
            case sections.indexOfObject(categoryText):
                return getCategoryCell(indexPath)
            case sections.indexOfObject(dealText):
                return getDealCell()
            case sections.indexOfObject(distanceText):
                return getDistanceCell()
            case sections.indexOfObject(sortText):
                return getSortCell(indexPath)
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == (allSections as NSArray).indexOfObject(categoryText) {
            if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == "olgaa.ToggleCell" {
                categoriesExpanded = !categoriesExpanded
                tableView.reloadData()
            }
        } else if indexPath.section == (allSections as NSArray).indexOfObject(sortText) {
            (tableView.cellForRowAtIndexPath(indexPath)! as SortCell).toggleSwitch()
        }
    }

    func getCategoryCell(indexPath: NSIndexPath) -> UITableViewCell {
        if !categoriesExpanded && indexPath.row == numPreviewCategories - 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("olgaa.ToggleCell") as ToggleCategoriesCell
            cell.setup(seeAllText)
            
            return cell
        } else {
            if indexPath.row == categories!.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("olgaa.ToggleCell") as ToggleCategoriesCell
                cell.setup(collapseText)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("olgaa.SwitchCell") as SwitchCell
                cell.setup(self, labelText: categories![indexPath.row]["name"]!, initialState: selectedCategories.containsObject(categories![indexPath.row]))
                return cell
            }
        }
    }
    
    func getDealCell() -> DealsCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("olgaa.DealsCell") as DealsCell
        cell.setup(self, state: filterByDeals)
        return cell
    }
    
    func getDistanceCell() -> DistanceCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("olgaa.DistanceCell") as DistanceCell
        cell.setup(self, distance: distance)
        return cell
    }
    
    func getSortCell(indexPath: NSIndexPath) -> SortCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("olgaa.SortCell") as SortCell
        cell.setup(self, labelText: allSorts[indexPath.row], initialValue: selectedSort == indexPath.row)
        return cell
    }
 
    // SwitchCellDelegate
    
    func switchCell(sc: SwitchCell, didUpdateValue: Bool) {
        let indexPath = tableView.indexPathForCell(sc)!
        if didUpdateValue {
            selectedCategories.addObject(categories![indexPath.row])
        } else {
            selectedCategories.removeObject(categories![indexPath.row])
        }
    }
    
    // DealCellDelegate
    
    func dealCell(dc: DealsCell, didUpdateValue: Bool) {
        filterByDeals = didUpdateValue
    }
    
    // SortTableViewCellDelegate
    
    func sortCell(sc: SortCell, valueUpdated: Bool) {
        selectedSort = tableView.indexPathForCell(sc)!.row
        tableView.reloadData()
    }
    
    // DistanceTableViewCellDelegate
    
    func distanceCell(dc: DistanceCell, valueChanged: Int) {
        distance = Float(valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Bar Button Actions
    
    func cancelButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func applyButtonPressed() {
        delegate?.filtersViewController(self, filters : filters)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getCategories() -> [[String: String]] {
        return [["name": "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Asturian", "code": "asturian"],
            ["name" : "Australian", "code": "australian"],
            ["name" : "Austrian", "code": "austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Bangladeshi", "code": "bangladeshi"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Bavarian", "code": "bavarian"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Beer Hall", "code": "beerhall"],
            ["name" : "Beisl", "code": "beisl"],
            ["name" : "Belgian", "code": "belgian"],
            ["name" : "Bistros", "code": "bistros"],
            ["name" : "Black Sea", "code": "blacksea"],
            ["name" : "Brasseries", "code": "brasseries"],
            ["name" : "Brazilian", "code": "brazilian"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "British", "code": "british"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Burmese", "code": "burmese"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New)"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "Chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comfortfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "german"],
            ["name" : "Giblets", "code": "giblets"],
            ["name" : "Gluten-Free", "code": "gluten_free"],
            ["name" : "Greek", "code": "greek"],
            ["name" : "Halal", "code": "halal"],
            ["name" : "Hawaiian", "code": "hawaiian"],
            ["name" : "Heuriger", "code": "heuriger"],
            ["name" : "Himalayan/Nepalese", "code": "himalayan"],
            ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name" : "Hot Dogs", "code": "hotdog"],
            ["name" : "Hot Pot", "code": "hotpot"],
            ["name" : "Hungarian", "code": "hungarian"],
            ["name" : "Iberian", "code": "iberian"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Indonesian", "code": "indonesian"],
            ["name" : "International", "code": "international"],
            ["name" : "Irish", "code": "irish"],
            ["name" : "Island Pub", "code": "island_pub"],
            ["name" : "Israeli", "code": "israeli"],
            ["name" : "Italian", "code": "italian"],
            ["name" : "Japanese", "code": "japanese"],
            ["name" : "Jewish", "code": "jewish"],
            ["name" : "Kebab", "code": "kebab"],
            ["name" : "Korean", "code": "korean"],
            ["name" : "Kosher", "code": "kosher"],
            ["name" : "Kurdish", "code": "kurdish"],
            ["name" : "Laos", "code": "laos"],
            ["name" : "Laotian", "code": "laotian"],
            ["name" : "Latin American", "code": "latin"],
            ["name" : "Live/Raw Food", "code": "raw_food"],
            ["name" : "Lyonnais", "code": "lyonnais"],
            ["name" : "Malaysian", "code": "malaysian"],
            ["name" : "Meatballs", "code": "meatballs"],
            ["name" : "Mediterranean", "code": "mediterranean"],
            ["name" : "Mexican", "code": "mexican"],
            ["name" : "Middle Eastern", "code": "mideastern"],
            ["name" : "Milk Bars", "code": "milkbars"],
            ["name" : "Modern Australian", "code": "modern_australian"],
            ["name" : "Modern European", "code": "modern_european"],
            ["name" : "Mongolian", "code": "mongolian"],
            ["name" : "Moroccan", "code": "moroccan"],
            ["name" : "New Zealand", "code": "newzealand"],
            ["name" : "Night Food", "code": "nightfood"],
            ["name" : "Norcinerie", "code": "norcinerie"],
            ["name" : "Open Sandwiches", "code": "opensandwiches"],
            ["name" : "Oriental", "code": "oriental"],
            ["name" : "Pakistani", "code": "pakistani"],
            ["name" : "Parent Cafes", "code": "eltern_cafes"],
            ["name" : "Parma", "code": "parma"],
            ["name" : "Persian/Iranian", "code": "persian"],
            ["name" : "Peruvian", "code": "peruvian"],
            ["name" : "Pita", "code": "pita"],
            ["name" : "Pizza", "code": "pizza"],
            ["name" : "Polish", "code": "polish"],
            ["name" : "Portuguese", "code": "portuguese"],
            ["name" : "Potatoes", "code": "potatoes"],
            ["name" : "Poutineries", "code": "poutineries"],
            ["name" : "Pub Food", "code": "pubfood"],
            ["name" : "Rice", "code": "riceshop"],
            ["name" : "Romanian", "code": "romanian"],
            ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name" : "Rumanian", "code": "rumanian"],
            ["name" : "Russian", "code": "russian"],
            ["name" : "Salad", "code": "salad"],
            ["name" : "Sandwiches", "code": "sandwiches"],
            ["name" : "Scandinavian", "code": "scandinavian"],
            ["name" : "Scottish", "code": "scottish"],
            ["name" : "Seafood", "code": "seafood"],
            ["name" : "Serbo Croatian", "code": "serbocroatian"],
            ["name" : "Signature Cuisine", "code": "signature_cuisine"],
            ["name" : "Singaporean", "code": "singaporean"],
            ["name" : "Slovakian", "code": "slovakian"],
            ["name" : "Soul Food", "code": "soulfood"],
            ["name" : "Soup", "code": "soup"],
            ["name" : "Southern", "code": "southern"],
            ["name" : "Spanish", "code": "spanish"],
            ["name" : "Steakhouses", "code": "steak"],
            ["name" : "Sushi Bars", "code": "sushi"],
            ["name" : "Swabian", "code": "swabian"],
            ["name" : "Swedish", "code": "swedish"],
            ["name" : "Swiss Food", "code": "swissfood"],
            ["name" : "Tabernas", "code": "tabernas"],
            ["name" : "Taiwanese", "code": "taiwanese"],
            ["name" : "Tapas Bars", "code": "tapas"],
            ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name" : "Tex-Mex", "code": "tex-mex"],
            ["name" : "Thai", "code": "thai"],
            ["name" : "Traditional Norwegian", "code": "norwegian"],
            ["name" : "Traditional Swedish", "code": "traditional_swedish"],
            ["name" : "Trattorie", "code": "trattorie"],
            ["name" : "Turkish", "code": "turkish"],
            ["name" : "Ukrainian", "code": "ukrainian"],
            ["name" : "Uzbek", "code": "uzbek"],
            ["name" : "Vegan", "code": "vegan"],
            ["name" : "Vegetarian", "code": "vegetarian"],
            ["name" : "Venison", "code": "venison"],
            ["name" : "Vietnamese", "code": "vietnamese"],
            ["name" : "Wok", "code": "wok"],
            ["name" : "Wraps", "code": "wraps"],
            ["name" : "Yugoslav", "code": "yugoslav"]]
    }
}

protocol FiltersViewControllerDelegate: class {
    func filtersViewController(filtersController: FiltersViewController, filters: NSDictionary)
}
