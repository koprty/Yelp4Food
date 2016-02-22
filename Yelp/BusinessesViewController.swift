//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UIScrollViewDelegate{
    @IBOutlet weak var yelpSearch: UISearchBar!

 //   @IBOutlet weak var ySearch: UISearchBar!
    //@IBOutlet weak var yelpSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var filteredData:[Business]!
    var businesses: [Business]!
    //var ySearch : UISearchBar
    var searchController: UISearchController!
    var offie : Int = 10
    //let offsets : Int = 10
    var isMoreDataLoading = false
    var limits : Int=10
    var loadingMoreView:InfiniteScrollActivityView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        businesses=[]
        filteredData = []
        Business.searchWithTerm("Thai", sort:nil,categories: nil,deals:nil, offset:offie, limit:limits, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            /*
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
            */
            self.offie += 5
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
        
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

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
    
    
    /* Infinite Scrolling */
    func scrollViewDidScroll(scrollView:UIScrollView){
        if (!isMoreDataLoading){
            let scrollviewContentHeight = tableView.contentSize.height
            let scrollOffsetThresh = scrollviewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThresh-20 && tableView.dragging){
                
                isMoreDataLoading = true

                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
            
       }
    }
    func loadMoreData(){
        if (self.businesses == nil){
            self.offie = 0
            loadMoreData()
            return
        }
         isMoreDataLoading = true
        var search_term = searchController.searchBar.text
        if searchController.searchBar.text == ""{
            search_term = "Chinese"
        }
        Business.searchWithTerm(search_term!, sort:nil,categories: nil,deals:nil, offset:offie, limit:limits, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            
            self.businesses.appendContentsOf(businesses)
            //self.businesses = Array(Set(self.businesses))
            //self.businesses = businesses
           // elf.tableView.reloadData()
            self.offie += 5
            })
        self.isMoreDataLoading = false
         self.loadingMoreView!.stopAnimating()
        
        self.tableView.reloadData()
        //task.resume()
    }
    
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .Gray
            activityIndicatorView.hidesWhenStopped = true
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.hidden = true
        }
        
        func startAnimating() {
            self.hidden = false
            self.activityIndicatorView.startAnimating()
        }
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
