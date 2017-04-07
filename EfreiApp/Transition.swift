//
//  Helper.swift
//  musifinder
//
//  Created by Paul Beneteau on 20/09/2016.
//  Copyright © 2016 TastyApp. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class TransitionSegue {
    static let segue = TransitionSegue()
    
     func switchToNavigationController() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyBoard.instantiateViewController(withIdentifier: "MenuVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
    }
    
    func switchToWalkThrough() {
        
        let storyBoard = UIStoryboard(name: "Walkthrough", bundle: nil)
        let naviVC = storyBoard.instantiateViewController(withIdentifier: "walkThrough")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
    }
    
    func switchToLoginview() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyBoard.instantiateViewController(withIdentifier: "loginView")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
    }
    
    func switchToLoginView() {
        
        /*
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("identifier") as? SecondViewController else {
            print("Could not instantiate view controller with identifier of type SecondViewController")
            return
        }
        
        vc.resultsArray = self.resultsArray
        self.navigationController?.pushViewController(vc, animated:true)
         */
    }
    
}





