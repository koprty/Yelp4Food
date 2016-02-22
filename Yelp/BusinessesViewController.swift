//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    @IBOutlet weak var yelpSearch: UISearchBar!

 //   @IBOutlet weak var ySearch: UISearchBar!
    //@IBOutlet weak var yelpSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var filteredData:[Business]!
    var businesses: [Business]!
    //var ySearch : UISearchBar
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        
        businesses=[]
        filteredData = []
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()

            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        filteredData = businesses
        /* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        
        for business in businesses {
        print(business.name!)
        print(business.address!)
        }
        }
        */
        
        
        
        
        // init array of filtered data
        filteredData = businesses
   
        
        /* customize nav bar */
        navigationItem.title = "Yelp 4 Food"
        
        //yelpSearch.delegate = self
        
        
      
        searchController =  UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        //tableView.tableHeaderView = searchController.searchBar
        automaticallyAdjustsScrollViewInsets = false
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* TABLE VIEW FUNCTIONS */
    func tableView(tableView:UITableView,numberOfRowsInSection section:Int) -> Int{
        if searchController.active && searchController.searchBar.text != ""{
        return filteredData.count
        }
        return businesses.count
    }
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        if filteredData.count > 0{
        cell.business = filteredData[indexPath.row]
        }else{
            cell.business = businesses[indexPath.row]
        }
        return cell
    }

    /* Search Bar Functions */
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
            if let searchText = searchController.searchBar.text{
                filteredData = searchText.isEmpty ? businesses: businesses.filter ({(bu_data:Business) -> Bool in
                    return bu_data.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                })
        }
        self.tableView.reloadData()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
