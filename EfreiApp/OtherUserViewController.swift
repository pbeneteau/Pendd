//
//  OtherUserViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 29/03/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import Cosmos

class OtherUserViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    var userId: String = ""
    var userFullName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        
        mainUser().initUserFirstName(userId: userId) { firstName in
            mainUser().initUserLastName(userId: self.userId) { lastName in
                mainUser().initAverageMark(userId: self.userId) { rating in
                    mainUser().initTotalHelps(userId: self.userId) { totalHelps in
                        
                        // Use var here
                        
                        self.userFullName = "\(firstName) \(lastName)"
                        self.userName.text = self.userFullName
                        self.ratingStars.rating = rating
                    }
                }
            }
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
