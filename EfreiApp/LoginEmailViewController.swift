//
//  LoginEmailViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 03/04/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import DynamicButton
import NVActivityIndicatorView
import FirebaseAuth
import FirebaseDatabase
import SkyFloatingLabelTextField

class LoginEmailViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var deviseLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var mailFieldButton: UIButton!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    
    @IBOutlet weak var SignUpView: UIView!
    @IBOutlet weak var SignUpLabel: UILabel!
    @IBOutlet weak var SignUpFirstNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var SignUpLastNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var SignUpCountryField: SkyFloatingLabelTextField!
    @IBOutlet weak var SignUpStateField: SkyFloatingLabelTextField!
    @IBOutlet weak var SignUpAddressField: SkyFloatingLabelTextField!
    @IBOutlet weak var SignUpZipcodeField: SkyFloatingLabelTextField!
    @IBOutlet weak var SignUpPhoneNumberLabel: SkyFloatingLabelTextField!
    @IBOutlet weak var SignUpContinueButtonView: UIView!
    @IBOutlet weak var SignUpContinueButton: DynamicButton!
    @IBOutlet weak var SignUpBackButton: DynamicButton!
    
    let backButton = DynamicButton(style: DynamicButtonStyle.arrowLeft)
    let continueButton = DynamicButton(style: DynamicButtonStyle.arrowRight)
    var continueButtonView  = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    var continueButtonLoadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    let loginView = UIView(frame: CGRect(x: 376, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let loginButtonView  = UIView(frame: CGRect(x: UIScreen.main.bounds.width * 0.87, y: UIScreen.main.bounds.height * 0.55, width: 70, height: 70))
    let loginButton = DynamicButton(style: DynamicButtonStyle.arrowRight)
    
    let forgotPasswordButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.55, width: 200, height: 30))
    let noAccountButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.6, width: 200, height: 30))
    
    let alertLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    
    let SignInContinueButtonLoadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    let signInPasswordView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let passwordTextField = UITextField()
    
    var signInPasswordField: SkyFloatingLabelTextField!
    var signInPasswordRepeatField: SkyFloatingLabelTextField!
    
    let animationOptions: UIViewAnimationOptions = .curveEaseOut
    
    var keyframeAnimationOptions: UIViewKeyframeAnimationOptions!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        
        keyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOptions.rawValue)
        
        configureEmailView()
        configureSignInView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureEmailView() {
        
        backButton.isHidden = true
        backButton.alpha = 0
        backButton.setStyle(DynamicButtonStyle.arrowLeft, animated: true)
        backButton.frame = CGRect(x: 15, y: 30, width: 35, height: 30)
        backButton.addTarget(self, action: #selector(self.backButtonTouched), for: .touchUpInside)
        
        continueButton.setStyle(DynamicButtonStyle.arrowRight, animated: true)
        continueButton.strokeColor = UIColor.white
        continueButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        continueButton.center = continueButtonView.center
        continueButton.addTarget(self, action: #selector(self.continueButtonTouched), for: .touchUpInside)
        
        continueButtonView.isHidden = true
        continueButtonView.backgroundColor = UIColor.black
        continueButtonView.layer.cornerRadius = continueButtonView.frame.size.width / 2
        continueButtonView.clipsToBounds = true
        
        continueButtonLoadingView.backgroundColor = UIColor.clear
        continueButtonLoadingView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        continueButtonLoadingView.center = continueButtonView.center
        continueButtonLoadingView.color = UIColor.white
        continueButtonLoadingView.type = .ballRotateChase
        
        mailTextField.addTarget(self, action: #selector(mailFieldEdited), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordFieldEdited), for: UIControlEvents.editingChanged)
        
        self.containerView.addSubview(backButton)
        self.containerView.addSubview(continueButtonView)
        self.continueButtonView.addSubview(continueButton)
        self.continueButtonView.addSubview(continueButtonLoadingView)
        
        backButtonTouched()
    }
    
    func configureSignInView() {
        
        SignUpView.frame.origin.x = screenSize.width + 1
        
        SignUpBackButton.setStyle(DynamicButtonStyle.arrowLeft, animated: true)
        SignUpBackButton.addTarget(self, action: #selector(signInInfosBackButtonTouched), for: .touchUpInside)
        
        SignUpContinueButton.isHidden = false
        SignUpContinueButton.setStyle(DynamicButtonStyle.arrowRight, animated: true)
        SignUpContinueButtonView.frame = CGRect(x: screenSize.width * 0.77, y: screenSize.height * 0.55, width: 70, height: 70)
        SignUpContinueButtonView.layer.cornerRadius = SignUpContinueButtonView.frame.width / 2
        
        SignInContinueButtonLoadingView.color = UIColor.white
        SignInContinueButtonLoadingView.type = .ballRotateChase
        SignInContinueButtonLoadingView.center = SignUpContinueButtonView.center
        SignUpContinueButtonView.addSubview(SignInContinueButtonLoadingView)
        
        SignUpLabel.frame.origin.y = screenSize.height * 0.16
        placeholderLabel.frame.origin.x = screenSize.width * 0.2
    }
    
    
    func mailFieldEdited() {
        
        if (mailTextField.text?.isEmpty)! {
            lineView.backgroundColor = UIColor.black
        } else {
            if LoginViewUtils().isValidEmail(testStr: mailTextField.text!) {
                lineView.backgroundColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            } else {
                lineView.backgroundColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
            }
        }
    }
    
    @IBAction func mailFieldTouched(_ sender: Any) {
        
        
        let currentViewHeight = self.view.frame.size.height
        let currentViewWidth = self.view.frame.size.width
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: keyframeAnimationOptions, animations: {
            
            self.placeholderLabel.frame.origin.y = currentViewHeight * 0.20
            self.placeholderLabel.frame.origin.x = self.deviseLabel.frame.origin.x
            self.placeholderLabel.alpha = 1
        })
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: keyframeAnimationOptions, animations: {
            
            self.containerView.frame.size.height = currentViewHeight
            self.containerView.frame.origin.y = 0
            
            self.mailTextField.frame.origin.y = currentViewHeight * 0.30
            self.mailTextField.attributedPlaceholder = NSAttributedString(string: "exemple@exemple.com", attributes: [NSForegroundColorAttributeName: UIColor(red:0.40, green:0.40, blue:0.40, alpha:0.25)])
            
            self.lineView.frame = CGRect(x: self.deviseLabel.frame.origin.x , y: currentViewHeight * 0.37, width: self.mailTextField.frame.size.width, height: 1)
            
            
            self.deviseLabel.alpha = 0
            self.aboutButton.alpha = 0
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            
            self.mailTextField.becomeFirstResponder()
            self.continueButtonView.frame = CGRect(x: currentViewWidth * 0.77, y: currentViewHeight * 0.55, width: 70, height: 70)
            if let savedValue = UserDefaults.standard.string(forKey: "loginUserMailSaved") {
                self.mailTextField.text = savedValue
            }
            UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: self.keyframeAnimationOptions, animations: {
                
                self.backButton.isHidden = false
                self.backButton.alpha = 1
                
                self.continueButtonView.isHidden = false
                self.continueButtonView.alpha = 1
                
                self.lineView.frame.size.height = 2
                self.lineView.backgroundColor = UIColor.black
                self.lineView.alpha = 1
            })
        })
        
        mailFieldButton.isHidden = true
    }
    
    func backButtonTouched() {
        
        mailTextField.text = ""
        continueButton.isHidden = false
        
        let currentViewHeight = self.view.frame.size.height
        let currentViewWidth = self.view.frame.size.width
        
        self.mailTextField.resignFirstResponder()
        
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: keyframeAnimationOptions, animations: {
            
            self.backButton.alpha = 0
            
            self.continueButtonView.alpha = 0
            self.continueButtonView.frame.origin.x += 70
            
            self.lineView.frame.size.height = 0.7
            self.lineView.backgroundColor = UIColor.black
            self.lineView.alpha = 0.1
        })
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: keyframeAnimationOptions, animations: {
            
            self.containerView.frame.size.height = currentViewHeight * 0.36
            self.containerView.frame.origin.y = currentViewHeight - currentViewHeight * 0.36
            
            self.placeholderLabel.frame.origin.y = currentViewHeight * 0.16
            self.placeholderLabel.frame.origin.x = currentViewWidth * 0.2
            self.placeholderLabel.alpha = 0.2
            
            self.mailTextField.frame.origin.y = currentViewHeight * 0.3
            self.mailTextField.placeholder = ""
            
            self.lineView.frame = CGRect(x: 0 , y: currentViewHeight * 0.28, width: currentViewWidth, height: 1)
            
            self.deviseLabel.alpha = 1
            self.aboutButton.alpha = 1
        })
        
        mailFieldButton.isHidden = false
        continueButtonView.isHidden = true
        backButton.isHidden = true
        
    }
    
    func continueButtonTouched() {
        
        if mailTextField.text?.isEmpty == false {
            if LoginViewUtils().isValidEmail(testStr: mailTextField.text!){
                
                continueButton.isHidden = true
                continueButtonLoadingView.startAnimating()
                
                let email = mailTextField.text
                
                LoginViewUtils().isEmailAlreadyUsed(email: email!) { emailState in
                    
                    if !emailState {
                        self.continueButtonLoadingView.stopAnimating()
                        self.switchToSignInInfosView()
                        
                    } else {
                        self.continueButtonLoadingView.stopAnimating()
                        self.switchToLoginView()
                    }
                }
            } else {
                printAlert(alert: "This is not a valid email address", success: false)
                print("not valid email")
            }
            
        } else {
            print("email field is empty")
        }
        
    }
    
    func switchToSignInInfosView() {
        
        _ = self.SignUpFirstNameField.becomeFirstResponder()
        
        SignUpContinueButton.addTarget(self, action: #selector(signInInfosContinueButton), for: .touchUpInside)
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: keyframeAnimationOptions, animations:{
            
            self.SignUpView.frame.origin.x = 0
            
            self.SignUpContinueButtonView.frame = CGRect(x: self.screenSize.width * 0.77, y: self.screenSize.height * 0.55, width: 70, height: 70)
            
        })
    }
    
    func signInInfosBackButtonTouched() {
        
        continueButton.isHidden = false
        SignUpView.addSubview(SignUpBackButton)
        SignUpBackButton.isHidden = false
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: keyframeAnimationOptions, animations: {
            
            self.SignUpView.frame.origin.x = self.screenSize.width + 1
        })
        
        mailTextField.becomeFirstResponder()
    }
    
    func signInInfosContinueButton() {
        
        let userInfos = [SignUpFirstNameField, SignUpLastNameField, SignUpCountryField, SignUpStateField, SignUpAddressField, SignUpZipcodeField, SignUpPhoneNumberLabel]
        
        var i = 0
        
        for info in userInfos {
            
            info?.lineColor = UIColor.black
            
            if (info?.text?.isEmpty)! {
                
                i = 1
                
                info?.lineColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
                
                let errorLabel = UILabel(frame: CGRect(x: SignUpPhoneNumberLabel.frame.origin.x, y: screenSize.height * 0.6, width: 200, height: 30))
                errorLabel.textColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
                errorLabel.font = SignUpLabel.font
                errorLabel.setSizeFont(sizeFont: 15)
                errorLabel.text = "There is an error somewhere!"
                
                SignUpView.addSubview(errorLabel)
            }
        }
        if i == 0 {
            
            switchToSignInPasswordView()
        }
    }
    
    func switchToSignInPasswordView() {
        
        SignUpContinueButton.removeTarget(nil, action: nil, for: .allEvents)
        SignUpContinueButton.addTarget(self, action: #selector(signInWithFirebase), for: .touchUpInside)
        
        signInPasswordView.frame = CGRect(x: screenSize.width + 1, y: 0, width: screenSize.width, height: screenSize.height)
        signInPasswordView.backgroundColor = UIColor.white
        view.addSubview(signInPasswordView)
        
        let backButton = SignUpBackButton
        backButton?.removeTarget(nil, action: nil, for: .allEvents)
        backButton?.addTarget(self, action: #selector(signInPasswordBackButtonTouched), for: .touchUpInside)
        signInPasswordView.addSubview(backButton!)
        
        let label = UILabel(frame: SignUpLabel.frame)
        label.textColor = UIColor.black
        label.text = "One more to go! Enter a password"
        label.font = placeholderLabel.font
        signInPasswordView.addSubview(label)
        
        signInPasswordField = SkyFloatingLabelTextField(frame: SignUpFirstNameField.frame)
        signInPasswordField.frame.size.width = screenSize.width * 0.6
        signInPasswordField.text = ""
        signInPasswordField.placeholder = "Enter Password"
        signInPasswordField.titleColor = SignUpFirstNameField.titleColor
        signInPasswordField.selectedTitleColor = SignUpFirstNameField.selectedTitleColor
        signInPasswordField.keyboardAppearance = UIKeyboardAppearance.dark
        signInPasswordField.isSecureTextEntry = true
        signInPasswordView.addSubview(signInPasswordField)
        
        signInPasswordRepeatField = SkyFloatingLabelTextField(frame: SignUpCountryField.frame)
        signInPasswordField.frame.size.width = screenSize.width * 0.6
        signInPasswordRepeatField.text = ""
        signInPasswordRepeatField.placeholder = "Retype Password"
        signInPasswordRepeatField.titleColor = SignUpFirstNameField.titleColor
        signInPasswordRepeatField.selectedTitleColor = SignUpFirstNameField.selectedTitleColor
        signInPasswordRepeatField.keyboardAppearance = UIKeyboardAppearance.dark
        signInPasswordRepeatField.isSecureTextEntry = true
        signInPasswordView.addSubview(signInPasswordRepeatField)
        
        SignUpContinueButtonView.frame.origin.x = screenSize.width + 1
        signInPasswordView.addSubview(SignUpContinueButtonView)
        
        _ = signInPasswordField.becomeFirstResponder()
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: keyframeAnimationOptions, animations: {
            
            self.signInPasswordView.frame.origin.x = 0
            self.SignUpContinueButtonView.frame.origin.x = self.screenSize.width * 0.77
        })
    }
    
    func signInPasswordBackButtonTouched() {
        
        SignUpContinueButton.removeTarget(nil, action: nil, for: .allEvents)
        SignUpContinueButton.addTarget(self, action: #selector(signInInfosBackButtonTouched), for: .touchUpInside)
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: keyframeAnimationOptions, animations: {
            self.signInPasswordView.frame.origin.x = self.screenSize.width + 1
            self.SignUpContinueButtonView.frame.origin.x = self.screenSize.width * 0.77
        })
    }
    
    func signInWithFirebase() {
        
        let errorLabel = UILabel(frame: CGRect(x: SignUpPhoneNumberLabel.frame.origin.x, y: screenSize.height * 0.6, width: 200, height: 30))
        errorLabel.textColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
        errorLabel.font = SignUpLabel.font
        errorLabel.setSizeFont(sizeFont: 15)
        errorLabel.text = ""
        
        if (signInPasswordField.text! == signInPasswordRepeatField.text!) {
            
            if (LoginViewUtils().isValidPassword(testStr: signInPasswordField.text!)) {
                
                FIRAuth.auth()?.createUser(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    
                    if error == nil {
                        
                        LoginViewUtils().sendUserInformations(user: (user?.uid)!
                            , email: self.mailTextField.text!, firstName: self.SignUpFirstNameField.text!, lastName: self.SignUpLastNameField.text!, country: self.SignUpCountryField.text!, state: self.SignUpStateField.text!, address: self.SignUpAddressField.text!, zipcode: self.SignUpZipcodeField.text!, phoneNumber: self.SignUpPhoneNumberLabel.text!)
                    } else {
                        print(String(describing: error?.localizedDescription))
                    }
                }
            } else {
                errorLabel.text = "Password not secure"
                signInPasswordField.lineColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
                signInPasswordRepeatField.lineColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
            }
        } else {
            errorLabel.text = "Passwords don't match"
            signInPasswordField.lineColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
            signInPasswordRepeatField.lineColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
        }
        signInPasswordView.addSubview(errorLabel)
    }
    
    func switchToLoginView() {
        
        let currentViewHeight = loginView.frame.size.height
        let currentViewWidth = loginView.frame.size.width
        
        loginView.backgroundColor = UIColor.white
        
        forgotPasswordButton.setTitle("I forgot my password", for: .normal)
        forgotPasswordButton.setTitleColor(UIColor(red:0.14, green:0.28, blue:0.61, alpha:1.0), for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .left
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTouched), for: .touchUpInside)
        
        noAccountButton.setTitle("I don't have any account", for: .normal)
        noAccountButton.setTitleColor(UIColor(red:0.14, green:0.28, blue:0.61, alpha:1.0), for: .normal)
        noAccountButton.addTarget(self, action: #selector(noAccountButtonTouched), for: .touchUpInside)
        noAccountButton.contentHorizontalAlignment = .left
        
        loginButtonView.backgroundColor = UIColor.black
        loginButtonView.layer.cornerRadius = 70 / 2
        loginButtonView.clipsToBounds = true
        
        loginButton.setStyle(DynamicButtonStyle.arrowRight, animated: true)
        loginButton.strokeColor = UIColor.white
        loginButton.frame = CGRect(x: (loginButtonView.frame.size.width - 30) / 2, y: (loginButtonView.frame.size.height - 30) / 2, width: 30, height: 30)
        loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        
        continueButtonLoadingView.frame = CGRect(x: (loginButtonView.frame.size.width - 50) / 2, y: (loginButtonView.frame.size.height - 50) / 2, width: 50, height: 50)
        
        passwordTextField.frame = CGRect(x: deviseLabel.frame.origin.x, y: mailTextField.frame.origin.y , width: 280, height: 30)
        passwordTextField.keyboardAppearance = mailTextField.keyboardAppearance
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = mailTextField.font
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password", attributes: [NSForegroundColorAttributeName: UIColor(red:0.40, green:0.40, blue:0.40, alpha:0.25)])
        
        backButton.removeTarget(nil, action: nil, for: .allEvents)
        backButton.addTarget(self, action: #selector(self.backPasswordTouched), for: .touchUpInside)
        
        placeholderLabel.text = "Welcome back, sign in to continue"
        
        lineView.backgroundColor = UIColor.black
        
        view.addSubview(loginView)
        loginView.addSubview(backButton)
        loginView.addSubview(passwordTextField)
        loginView.addSubview(loginButtonView)
        loginView.addSubview(forgotPasswordButton)
        loginView.addSubview(noAccountButton)
        loginView.addSubview(lineView)
        loginView.addSubview(placeholderLabel)
        loginButtonView.addSubview(loginButton)
        loginButtonView.addSubview(continueButtonLoadingView)
        
        loginButtonView.frame = CGRect(x: currentViewWidth * 0.87 + 50, y: currentViewHeight * 0.55, width: 70, height: 70)
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: keyframeAnimationOptions, animations: {
            self.continueButtonView.frame.origin.x = -100
            self.continueButtonView.alpha = 0
        })
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0.4, options: keyframeAnimationOptions, animations: {
            
            self.loginButtonView.frame = CGRect(x: currentViewWidth * 0.77, y: currentViewHeight * 0.55, width: 70, height: 70)
            
            self.loginView.frame.origin.x = 0
            
            self.containerView.backgroundColor = UIColor.lightGray
            
        })
        
        passwordTextField.becomeFirstResponder()
    }
    
    func loginButtonTouched() {
        
        if (passwordTextField.text?.isEmpty)! {
            
            printAlert(alert: "Please enter your password", success: false)
        } else {
            
            continueButtonLoadingView.startAnimating()
            loginButton.isHidden = true
            
            FIRAuth.auth()?.signIn(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    self.printAlert(alert: "You are successfuly logged in!", success: true)
                    print("user successfuly logged in with ID: \(String(describing: FIRAuth.auth()?.currentUser?.uid))")
                } else {
                    self.printAlert(alert: (error?.localizedDescription)!, success: false)
                }
                self.continueButtonLoadingView.stopAnimating()
                self.loginButton.isHidden = false
            }
        }
    }
    
    func passwordFieldEdited() {
        
        if !(passwordTextField.text?.isEmpty)! {
            lineView.backgroundColor = UIColor.black
            alertLabel.isHidden = true
        }
    }
    
    func backPasswordTouched() {
        
        containerView.addSubview(backButton)
        containerView.addSubview(lineView)
        containerView.addSubview(placeholderLabel)
        
        placeholderLabel.text = "Enter your email address"
        continueButton.isHidden = false
        continueButtonLoadingView.isHidden = false
        
        continueButtonView.frame = CGRect(x: screenSize.width * 0.77, y: screenSize.height * 0.55, width: 70, height: 70)
        continueButtonView.alpha = 1
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: keyframeAnimationOptions, animations: {
            
            self.loginView.frame.origin.x = self.screenSize.width + 1
            self.containerView.backgroundColor = UIColor.white
        })
        
        backButton.removeTarget(nil, action: nil, for: .allEvents)
        backButton.addTarget(self, action: #selector(self.backButtonTouched), for: .touchUpInside)
        
        continueButtonView.layer.cornerRadius = continueButtonView.frame.height / 2
        
        passwordTextField.text = ""
    }
    
    func forgotPasswordButtonTouched() {
        print("forgotPasswordButton touched")
        
        if (mailTextField.text?.isEmpty)! {
            print("Enter an email address")
            
        } else {
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: mailTextField.text!, completion: { (error) in
                
                if error != nil {
                    
                    self.printAlert(alert: "Error", success: false)
                    print(error?.localizedDescription as Any)
                    
                } else {
                    self.printAlert(alert: "You will receive an email", success: true)
                }
            })
        }
    }
    
    func noAccountButtonTouched() {
        print("noAccountButton touched")
    }
    
    func printAlert(alert: String, success: Bool) {
        
        alertLabel.frame = CGRect(x: lineView.frame.origin.x, y: lineView.frame.origin.y + 5, width: lineView.frame.width, height: 30)
        alertLabel.text = alert
        
        if !success { // error
            alertLabel.textColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
            lineView.backgroundColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
        } else { // success
            alertLabel.textColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            lineView.backgroundColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
        }
        
        alertLabel.isHidden = false
        
        loginView.addSubview(alertLabel)
    }
}

extension UIViewKeyframeAnimationOptions {
    
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
    
}

extension UILabel {
    func setSizeFont (sizeFont: Double) {
        self.font =  UIFont(name: self.font.fontName, size: CGFloat(sizeFont))!
        self.sizeToFit()
    }
}
