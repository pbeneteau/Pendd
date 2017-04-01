//
//  AsksArroundViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 25/02/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import DGElasticPullToRefresh
import NVActivityIndicatorView


class AsksArroundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    let locationClass = locationHelp()
    
    var refHande: UInt!
    
    var tasksList = [asksArround]()
    private var filteredTasksList = [asksArround]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let refreshControl = UIRefreshControl()
    
    
    private var countryCode: String?
    private var state: String?
    private var userLocation: CLLocation?
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    
    
    var cellHeights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        
        searchController.searchResultsUpdater = self
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        
        //configureSearchController()
        //tableView.dg_removePullToRefresh()
        
        //initTableView()
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...(tasksList.count) {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    func initTableView() {
        
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        searchController.searchBar.isHidden = true
    }
    
    func retrieveData() {
        
        self.startActivityIndicator()
        
        locationClass.setLocation { success in
            if success {
                
                self.userLocation = self.locationClass.getLocation()
                
                self.countryCode =  self.locationClass.getCountryCode()
                
                self.state = self.locationClass.getState()
                
                self.fetchAsks() { end in
                    if end {
                        print("Done")
                        self.createCellHeightsArray()
                    } else {
                        
                        print("out")
                    }
                }
            }
        }
    }
    
    func startActivityIndicator() {
        self.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.maxX/2 - 25, y: self.view.frame.maxY/2 - 25, width: 50, height: 50), type: .ballBeat, color: UIColor.white, padding: 0)
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredTasksList.count : tasksList.count
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            let task: asksArround = tasksList[indexPath.row]
            
            if segue.identifier == "userProfile" {
                
                let profileViewController = segue.destination as! OtherUserViewController
                
                let userId = task.user
                
                profileViewController.userId = userId!
                
            } else if segue.identifier == "submitHelp" {
                
                let submitHelpViewcontroller = segue.destination as! SubmitHelpProposalViewController
                
                submitHelpViewcontroller.detailTask = task
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard case let cell as AsksArroundTableViewCell = cell else {
            return
        }
        
        let task = searchController.isActive ? filteredTasksList[indexPath.row] : tasksList[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        cell.titleLabel.text = task.title
        cell.number = indexPath.row
        
        if Float(task.distance!) > 1000 {
            cell.distanceLabel.text = String(format: "%.1fkm", Float(task.distance!) / 1000)
        } else {
            cell.distanceLabel.text = "\(task.distance!)m"
        }
        cell.priceLabel.text = "$\(task.price!)"
        cell.priceLabel2.text = "$\(task.price!)"
        cell.priceLabel2.text = "$\(task.price!)"
        cell.locationLabel.text = task.address
        cell.categoryLabel.text = task.category
        cell.cityLabel.text = task.address
        cell.streetLabel.text = task.street
        
        Time().convertDateToString(format: 1, dateToConvert: task.date!) { day in
            
            cell.dayLabel.text = day.uppercased()
        }
        Time().convertDateToString(format: 0, dateToConvert: task.date!) { hour in
            
            cell.hourLabel.text = hour
            cell.hourLabel2.text = hour
        }
        Time().convertDateToString(format: 2, dateToConvert: task.date!) { date in
            cell.dateLabel.text = date.uppercased()
        }
        
        mainUser().initUserFirstName(userId: task.user) { firstName in
            
            mainUser().initUserLastName(userId: task.user) { lastName in
                cell.userName.text = "\(firstName) \(lastName)"
            }
        }
        
        mainUser().initAverageMark(userId: task.user) { rating in
            cell.ratingStarsView.rating = rating
        }
        
        cell.userButton.addTarget(self, action: #selector(self.someAction), for: .touchUpInside)
        
        cell.userLocation = self.userLocation!
        cell.taskLocation = task.location
        cell.centerMapOnLocation(location: task.location)
        cell.taskDate = Time().convertStringToDate(date: task.date!)
        cell.requestDeadlineLabel.text = Time().timeRemainingString(finishDate: Time().convertStringToDate(date: task.date!) as NSDate)
        
        activityIndicatorView.stopAnimating()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Folding", for: indexPath)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[(indexPath as NSIndexPath).row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
        
    }
    
    func someAction() {
        self.performSegue(withIdentifier: "userProfile", sender: self)
    }
    
    func refreshData(sender: UIRefreshControl) {
        fetchAsks() { end in
            
            self.refreshControl.endRefreshing()
        }
        
    }
    
    func fetchAsks(completionHandler: @escaping (_ end: Bool) -> ()) {
        
        self.tasksList.removeAll()
        
        refHande = ref.child("asks").child(self.countryCode!).child(self.state!).observe(.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                if let dict = snapshot.value as? [String : [String:Any]] {
                    for (task, value) in dict {
                        if let user: String = value["user"] as? String {
                            if let title: String = value["title"] as? String {
                                if let description: String = value["description"] as? String {
                                    if let price: String = value["price"] as? String {
                                        if let taskAddress: String = value["address"] as? String, let taskStreet = value["street"] as? String {
                                            
                                            self.locationClass.coordinatesFromAdress(address: "\(taskAddress) \(taskStreet)") { coordinates in
                                                
                                                let taskDistance: Int = Int(self.locationClass.getLocationsDistance(location1: coordinates, location2: self.locationClass.getLocation()))
                                                
                                                if let date: String = value["date"] as? String {
                                                    if let category: String = value["category"] as? String {
                                                        print(category)
                                                        
                                                        if Time().isPast(date: date) {
                                                            
                                                            self.ref.child("asks").child(self.countryCode!).child(self.state!).child(category).child(task).removeValue { (error, ref) in
                                                                if error != nil {
                                                                    print("error \(String(describing: error))")
                                                                }
                                                            }
                                                        } else {
                                                            print("distance ok")
                                                            if taskDistance <= 20000 {
                                                                let taskArray = asksArround(title: title, description: description, distance: taskDistance, address: taskAddress, street: taskStreet, date: date, category: category, price: price, location: coordinates, user: user)
                                                                
                                                                self.tasksList.append(taskArray)
                                                                
                                                                self.tasksList.sort(by: { Int($0.distance!) < Int($1.distance!) })
                                                                self.tableView.reloadData()
                                                                
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            completionHandler(true)
        })
        
    }
    
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "task 1", "task 2", "task 3"]
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor(red:0.90, green:0.36, blue:0.33, alpha:1.0)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.layer.borderWidth = 0
        searchController.searchBar.layer.borderColor = UIColor.clear.cgColor
        let searchTextField = searchController.searchBar.value(forKey: "_searchField") as? UITextField
        searchTextField?.backgroundColor = UIColor(red:0.90, green:0.36, blue:0.33, alpha:1.0)
        searchTextField?.textColor = UIColor.white
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchController(searchBar: searchController.searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterSearchController(searchBar: searchBar)
    }
    
    func filterSearchController(searchBar: UISearchBar) {
        
        guard let scopeString = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else { return }
        let selectedElement = asksArround.Category(rawValue: scopeString) ?? .All
        let searchText = searchBar.text ?? ""
        // filter pokemonList by element and text
        filteredTasksList = tasksList.filter { task in
            let isElementMatching = (selectedElement == .All) || (task.categoryEnum == selectedElement)
            let isMatchingSearchText = (task.title?.lowercased().contains(searchText.lowercased()))! || searchText.lowercased().characters.count == 0
            return isElementMatching && isMatchingSearchText
        }
        tableView.reloadData()
    }

    @IBAction func searchButton(_ sender: Any) {
        
    }
    
}
