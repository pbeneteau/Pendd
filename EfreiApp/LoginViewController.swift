//
//  LoginViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 18/01/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import CoreLocation
import PhoneNumberKit

class LoginViewController: keyboardUtils, NVActivityIndicatorViewable {
    
    // Sign in
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var telField = PhoneNumberTextField()
    @IBOutlet weak var adressField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    
    
    // Sign up
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var selectionBar: UIView!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    var state: String = ""
    
    let x = UIScreen.main.bounds.maxX/2 - 25
    
    var aiView = NVActivityIndicatorView(frame: CGRect(x: 162.5, y: 594.5, width: 50, height: 50))
    
    var actualView: String = "login"
    
    let ref = FIRDatabase.database().reference() // Firebase database ref
    let user = FIRAuth.auth()?.currentUser // User ref
    
    let keyboardClass = keyboardUtils!.self
    
    let phoneNumberKit = PhoneNumberKit()
    var dialingCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user != nil {
            // if user already logged in...
            transitionSegue.segue.switchToNavigationController()
        }
        
        loginView.frame.origin.x = 39.5
        signInView.frame.origin.x = 39.5 - 400
        
        initButtons()
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            dialingCode = String(describing: phoneNumberKit.countryCode(for: countryCode)!)
        }
        
        setPredictiveState(state: .no)
        
        initSwipe(initView: signInView)
        initSwipe(initView: loginView)
        
        addObservers()
        
        // delegates for textFields
        setDelegates(nameField, emailField, passwordField, loginEmailField,  loginPasswordField, telField!, adressField, countryField, lastNameField, zipcodeField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initButtons() {
        
        aiView = NVActivityIndicatorView(frame: CGRect(x: x, y: 594.5, width: 50, height: 50))
        self.SignUpButton.setTitle("Sign Up", for: .normal)
        self.SignInButton.setTitle("Sign In", for: .normal)
        self.SignUpButton.frame.size.width = 296
        self.SignInButton.frame.size.width = 296
        self.SignInButton.frame.origin.x = 39.5
        self.SignUpButton.frame.origin.x = 39.5
        if actualView == "login" {
            SignUpButton.frame.origin.y = 590
            SignInButton.frame.origin.y = 675
        } else {
            SignUpButton.frame.origin.y = 675
            SignInButton.frame.origin.y = 590
        }
        SignUpButton.layer.cornerRadius = 0
        SignInButton.layer.cornerRadius = 0
    }
    
    func buttonLoadingAnimation() {
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
            
            self.SignUpButton.layer.cornerRadius = 30
            self.SignUpButton.frame.size.width = 59
            self.SignUpButton.frame.origin.x = self.x - 4.5
            self.SignInButton.setTitle("",for: .normal)
            self.SignInButton.layer.cornerRadius = 30
            self.SignInButton.frame.size.width = 59
            self.SignInButton.frame.origin.x = self.x - 4.5
            self.SignUpButton.setTitle("", for: .normal)
            self.SignInButton.setTitle("", for: .normal)
        })
        
        aiView.color = .white
        aiView.type = .ballScaleMultiple
        aiView.startAnimating()
        view.addSubview(aiView)
    }
    
    func initSwipe(initView: UIView) {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        initView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        initView.addGestureRecognizer(swipeLeft)
    }
    
    // Signin
    @IBAction func signInButtonAction(_ sender: Any) {
        dismissKeyboard()
        
        if ((emailField.text == "") || (passwordField.text == "") || (nameField.text == "") || (telField?.text == "") || (telField?.text == "+\(dialingCode!) ") || (adressField.text == "") || (countryField.text == "") || (zipcodeField.text == "") || (lastNameField.text == "") || state == ""){
            
            messageAlert(title: "Error!", message: "Please enter all informations needed")
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                
                if error == nil {
                    self.buttonLoadingAnimation()
                    
                    // Send data
                    self.ref.child("users").child(user!.uid).child("firstName").setValue(self.nameField.text)
                    self.ref.child("users").child(user!.uid).child("lastName").setValue(self.lastNameField.text)
                    self.ref.child("users").child(user!.uid).child("email").setValue(self.emailField.text)
                    
                    
                    self.ref.child("users").child(user!.uid).child("tel").setValue(PartialFormatter().formatPartial((self.telField?.text)!))
                    self.ref.child("users").child(user!.uid).child("address").setValue(self.adressField.text)
                    self.ref.child("users").child(user!.uid).child("zipCode").setValue(self.zipcodeField.text)
                    self.ref.child("users").child(user!.uid).child("country").setValue(self.countryField.text)
                    self.ref.child("users").child(user!.uid).child("state").setValue(self.state)
                    self.ref.child("users").child(user!.uid).child("address").setValue("\(String(describing: self.countryField.text!)), \(self.state) \(String(describing: self.zipcodeField.text!))")
                    self.ref.child("users").child(user!.uid).child("street").setValue("\(String(describing: self.adressField.text!))")
                    
                    // Send other default infos
                    let days = ["monday", "tuesday", "wednesday", "friday", "thursday", "saturday", "sunday", "mondayAm", "tuesdayAm", "wednesdayAm", "fridayAm", "thursdayAm", "saturdayAm", "sundayAm"]
                    
                    for n in 0...13 {
                        self.ref.child("users").child((user?.uid)!).child("availability").child(days[n]).setValue(true)
                    }
                    self.ref.child("users").child((user?.uid)!).child("mark").setValue(0)
                    self.ref.child("users").child((user?.uid)!).child("totalHelps").setValue(0)
                    self.ref.child("users").child((user?.uid)!).child("rates").setValue(0)
                    
                    transitionSegue.segue.switchToNavigationController()
                    
                } else {
                    
                    self.messageAlert(title: "Error!", message: (error?.localizedDescription)!)
                }
                self.aiView.stopAnimating()
                UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
                    self.initButtons()
                })
            }
        }
    }
    
    // Login
    @IBAction func loginButton(_ sender: Any) {
        dismissKeyboard()
        
        if self.loginEmailField.text == "" || self.loginPasswordField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            messageAlert(title: "Error!", message: "Please enter your password and email")
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.loginEmailField.text!, password: self.loginPasswordField.text!) { (user, error) in
                
                if error == nil {
                    self.buttonLoadingAnimation()
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    self.messageAlert(title: "Error", message: (error?.localizedDescription)!)
                }
                self.aiView.stopAnimating()
                UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
                    self.initButtons()
                })
            }
        }
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        
        if self.loginEmailField.text == "" {
            
            messageAlert(title: "Oops!", message: "Please enter an email.")
            
        } else {
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.loginEmailField.text!, completion: { (error) in
                
                if error != nil {
                    self.messageAlert(title: "Error!", message: (error?.localizedDescription)!)
                    
                } else {
                    self.messageAlert(title: "Sucess!", message: "A mail have been sent.")
                    self.loginEmailField.text = ""
                }
            })
        }
    }
    
    func messageAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func showLoginView(_ sender: Any) {
        animation()
    }
    
    @IBAction func showSigninView(_ sender: Any) {
        animation()
    }
    
    func setPredictiveState(state: UITextAutocorrectionType) {
        
        let array = [nameField, emailField, passwordField, adressField, telField, loginPasswordField, loginEmailField]
        
        for object in array {
            object?.autocorrectionType = state
        }
    }
    
    func animation() {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: .allowUserInteraction, animations: {
            
            if self.actualView == "signin" {
                self.actualView = "login"
                self.selectionBar.frame.origin.x += 185.5
                if self.signInView.frame.origin.x != -439 {
                    self.signInView.frame.origin.x -= 400.0
                    self.SignInButton.frame.origin.y = 675
                    self.SignUpButton.frame.origin.y = 590
                }
                self.loginView.frame.origin.x -= 400.0
                
            } else {
                self.actualView = "signin"
                self.selectionBar.frame.origin.x -= 185.5
                self.signInView.frame.origin.x += 400.0
                self.loginView.frame.origin.x += 400.0
                self.SignInButton.frame.origin.y = 590
                self.SignUpButton.frame.origin.y = 675
            }
        })
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                if actualView == "signin" {
                    animation()
                }
            case UISwipeGestureRecognizerDirection.right:
                if actualView == "login" {
                    animation()
                }
            default:
                break
            }
        }
    }
    
    @IBAction func zipCodeEditingEnd(_ sender: Any) {
        if (zipcodeField.text != "") {
            getStateFromZip(zipCode: zipcodeField.text!)
        }
    }
    
    func getStateFromZip(zipCode: String) {
        let zipCode = zipCode
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipCode) {
            (placemarks, error) -> Void in
            // Placemarks is an optional array of CLPlacemarks, first item in array is best guess of Address
            
            if let placemark = placemarks?[0] {
                
                self.state = placemark.administrativeArea!
                print(self.state)
            }
        }
    }
    @IBAction func phoneNumberBeginEdited(_ sender: Any) {
        self.telField?.placeholder = "+\(self.dialingCode!) "
        
    }
}
