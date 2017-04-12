//
//  TaskDetailViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 28/02/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import EventKit
import Cosmos


class SubmitHelpProposalViewController: UIViewController {

    
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var taskDistanceLabel: UILabel!
    @IBOutlet weak var taskAddressLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UITextView!
    @IBOutlet weak var userRatingStars: CosmosView!
    
    var taskTitle: String = ""
    var taskDescription: String = ""
    var taskAddress: String = ""
    var taskDate: String = ""
    var taskDistance: Int = 0
    
    var userPhoneNumber: String = ""
    var userId: String = ""
    var userName: String = ""
    
    let df: DateFormatter = DateFormatter()
    
    var detailTask: asksArround? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {

        
        if let detailTask = detailTask {
            
            if let typeLabel = taskTypeLabel, let dateLabel = taskDateLabel, let distanceLabel = taskDistanceLabel, let addressLabel = taskAddressLabel, let descriptionLabel = taskDescriptionLabel {
                
                userId = detailTask.user
                
                typeLabel.text = detailTask.title
                dateLabel.text = detailTask.date
                
                distanceLabel.text = "\(Int(detailTask.distance!))m"
                if detailTask.distance! > 1000 {
                    distanceLabel.text = String(format: "%.1fkm", Float(detailTask.distance!) / 1000)
                }
                addressLabel.text = detailTask.address
                descriptionLabel.text = detailTask.description
                
                if let ratingStars = userRatingStars {
                    mainUser().initAverageMark(userId: userId) { rating in
                        ratingStars.rating = rating
                        
                    }
                }
            }
            
            taskAddress = (detailTask.address!)
            taskTitle = (detailTask.title!)
            taskDate = (detailTask.date!)
            taskDistance = Int(detailTask.distance!)
            
            mainUser().initUserPhoneNumber(userId: detailTask.user) { phoneNumber in
                
                self.userPhoneNumber = phoneNumber
            }
        }
    }
    
    @IBAction func declineButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptTaskButton(_ sender: Any) {

        _ = NSCalendar.current
        
        _ = "Address: \(taskAddress)"
        
        //let beginDateString = self.nsDate
        
        df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //print(beginDateString)
        //let beginDate = df.date(from: beginDateString)
        
        //let endDate = calendar.date(byAdding: .hour, value: 2, to: beginDate!)
        
        print("Adding to calendar")
        
        //addEventToCalendar(title: task, description: description, startDate: beginDate!, endDate: endDate!)
    }
    
    func openMap(scheme: String) {        
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    func phoneNumberFormat() {
        
    }
}
