//
//  ProfileTabsViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 12/04/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ProfileTabsViewController: TabmanViewController, PageboyViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        bar.style = .bar
        
        bar.location = .top
        
        bar.appearance = TabmanBar.Appearance({ (appearance) in
            // customise appearance here
            
            
            appearance.indicator.color = UIColor.lightGray
            
            appearance.indicator.useRoundedCorners = true
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func viewControllers(forPageboyViewController pageboyViewController: PageboyViewController) -> [UIViewController]? {
        
        let pendingVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileTabPending")
        let asksVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileTabAsks")
        let helpsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileTabHelps")
        
        // return array of view controllers
        let viewControllers = [pendingVC, asksVC, helpsVC]
        
        // configure the bar
        self.bar.items = [TabmanBarItem(title: "Pending"),
                          TabmanBarItem(title: "Asks"),
                          TabmanBarItem(title: "Helps")]
        
        return viewControllers as? [UIViewController]
    }
    
    func defaultPageIndex(forPageboyViewController pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex? {
        // use default index
        return nil
    }
    

}
