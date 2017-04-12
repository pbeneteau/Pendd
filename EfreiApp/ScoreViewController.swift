//
//  ScoreViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 03/03/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import Firebase
import InteractiveSideMenu

class ScoreViewController: MenuItemContentViewController {
    
    
    @IBOutlet weak var averageMarkLabel: UILabel!
    @IBOutlet weak var totalAsksLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var profileCompletionLabel: UILabel!
    @IBOutlet weak var totalHelpsLabel: UILabel!
    
    private var averageMark: Double!
    private var totalAsks: Double!
    private var totalHelps: Double!
    private var ratioHA: Double!
    private var user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initInfos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initInfos() {
        mainUser().initAverageMark(userId: (user?.uid)!){ mark in
            self.averageMarkLabel.text = "Review: \(mark)"
            
            mainUser().initTotalHelps(userId: (self.user?.uid)!) { total in
                self.totalHelpsLabel.text = "Total helps completed: \(total)"
                
                mainUser().initTotalAsks(userId: (self.user?.uid)!) { total1 in
                    self.totalAsksLabel.text = "Total asks sent: \(total1)"
                    self.ratioLabel.text = "Ratio Helps/Asks: \(total/total1)"
                }
            }
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        showMenu()
    }
}
