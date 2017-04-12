//
//  CurrentUserProfileViewController.swift
//
//
//  Created by Paul Bénéteau on 03/03/2017.
//
//

import UIKit
import Firebase
import InteractiveSideMenu

class CurrentUserProfileViewController: MenuItemContentViewController {
    
    let ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    
    let animationOptions: UIViewAnimationOptions = .curveEaseOut
    var keyframeAnimationOptions: UIViewKeyframeAnimationOptions!
    
    
    var userName: String = ""
    var userEmail: String = ""
    var userAddress: String = ""
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initInfos()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initInfos() {
        mainUser().initUserFirstName(userId: (user?.uid)!) { firstName in
            mainUser().initUserLastName(userId: (self.user?.uid)!) { lastName in
                self.userNameLabel.text = "\(firstName) \(lastName)"
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        self.view.backgroundColor = UIColor(red:0.88, green:0.31, blue:0.31, alpha:1.0)
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeLinear, animations: {
            
            self.containerView.frame.origin.y += self.logoutButton.frame.height
            
        })
    }
    
    @IBAction func confirmLogoutButton(_ sender: Any) {
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeDiscrete, animations: {
            
            self.containerView.frame.origin.y -= self.logoutButton.frame.height
        })
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.view.backgroundColor = UIColor.white
            
            if FIRAuth.auth()?.currentUser != nil {
                do {
                    try FIRAuth.auth()?.signOut()
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
                    self.present(vc, animated: true, completion: nil)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            print("user did logout")
        })
    }
    
    @IBAction func cancelLogout(_ sender: Any) {
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeCubic, animations: {
            
            self.containerView.frame.origin.y -= self.logoutButton.frame.height
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.containerView.backgroundColor = UIColor.white
        })
        
    }
    
    @IBAction func menuButton(_ sender: Any) {
        showMenu()
    }
    
    
}

extension UIViewKeyframeAnimationOptions {
    
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
    
}
