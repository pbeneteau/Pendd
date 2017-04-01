//
//  UserAsksViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 03/03/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import Firebase

class UserAsksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "cellID"
    var refHande: UInt!
    
    var asksList = [userAsks]()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red:0.24, green:0.63, blue:0.82, alpha:1.0)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAsks()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let task: userAsks = asksList[indexPath.row]
        
        cell.textLabel?.text = task.type
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.text = task.date
        cell.detailTextLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor(red:0.22, green:0.69, blue:0.89, alpha:1.0)
        
        return cell
    }
    
    /*
     // MARK: - Segues
     override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
     if segue.identifier == "showTaskDetail" {
     
     if let indexPath = tableView.indexPathForSelectedRow {
     let controller = segue.destination as! TaskDetailViewController
     let task: userAsks
     task = asksList[indexPath.row]
     controller.detailTask = task
     }
     }
     }
     
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     self.performSegue(withIdentifier: "showTaskDetail", sender: indexPath);
     tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
     }
     */
    
    func refreshData(sender: UIRefreshControl) {
        fetchAsks()
        refreshControl.endRefreshing()
    }
    
    func fetchAsks() {
        
        self.asksList.removeAll()
        
        refHande = ref.child("users").child((user?.uid)!).child("asks").observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String : [String:Any]] {
                for (_, value) in dict {
                    if let title: String = value["title"] as? String {
                        if let taskDate = value["date"] as? String {
                            if let taskPrice = value["price"] as? String {
                                if let taskAddress: String = value["address"] as? String {
                                    let asksArray = userAsks(date: taskDate, type: title, address: taskAddress, price: taskPrice)
                                    self.asksList.append(asksArray)
                                }
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        })
        
    }
}
