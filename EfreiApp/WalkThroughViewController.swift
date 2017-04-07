//
//  WalkThroughViewController.swift
//  LittleWorld
//
//  Created by Paul Bénéteau on 13/01/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import BWWalkthrough

class WalkThroughViewController: UIViewController, BWWalkthroughViewControllerDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWalkthrough()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

     func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_zero)
        
        self.present(walkthrough, animated: false, completion: nil)
    }
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
    }
    
    func walkthroughCloseButtonPressed() {
        TransitionSegue.segue.switchToNavigationController()
    }
}
