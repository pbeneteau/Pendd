//
//  CurrentUserProfileViewController.swift
//
//
//  Created by Paul Bénéteau on 03/03/2017.
//
//

import UIKit
import Firebase

class CurrentUserProfileViewController: UIViewController {
    
    let ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    
    var userName: String = ""
    var userEmail: String = ""
    var userAddress: String = ""
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAddressLabel: UILabel!
    
    @IBOutlet weak var editAddressView: UIView!
    @IBOutlet weak var editAddressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editAddressView.isHidden = true
        initInfos()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    func initInfos() {
        mainUser().initUserFirstName(userId: (user?.uid)!) { firstName in
            mainUser().initUserLastName(userId: (self.user?.uid)!) { lastName in
                self.userNameLabel.text = "\(firstName) \(lastName)"
                self.userEmailLabel.text = self.user?.email
            }
        }
        
        locationHelp().retrieveUserDatabaseAdress(userID: (user?.uid)!) { address in
            self.userAddressLabel.text = address
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editAddressButton(_ sender: Any) {
        editAddressView.isHidden = false
    }
    
    @IBAction func editAddressSubmit(_ sender: Any) {
        ref.child("users").child((user?.uid)!).child("email").setValue(editAddressField.text)
        editAddressView.isHidden = true
    }
    
    @IBAction func scoreButton(_ sender: Any) {
    }
}
