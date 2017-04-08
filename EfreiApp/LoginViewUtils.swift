//
//  LoginViewUtils.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 07/04/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import PhoneNumberKit


class LoginViewUtils {


    func isEmailAlreadyUsed(email: String, completionHandler: @escaping (_ mailState: Bool) -> ()) {
        
        FIRAuth.auth()?.fetchProviders(forEmail: email, completion: { (stringArray, error) in
            
            if error != nil {
                print(error!)
            } else {
                if stringArray == nil {
                    completionHandler(false)
                    print("No password. No active account")
                } else {
                    completionHandler(true)
                    print("There is an active account")
                }
            }
        })
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(testStr:String) -> Bool {
        let passwordRegEx = "^.*(?=.{6,})(?=.*[A-Z]).*$"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: testStr)
    }

    func sendUserInformations(user: String, email: String, firstName: String, lastName: String, country: String, state: String, address: String, zipcode: String, phoneNumber: String) {
        
        let ref = FIRDatabase.database().reference()
        
        // Send important user informations
        ref.child("users").child(user).child("firstName").setValue(firstName)
        ref.child("users").child(user).child("lastName").setValue(lastName)
        ref.child("users").child(user).child("phoneNumber").setValue(PartialFormatter().formatPartial(phoneNumber))
        ref.child("users").child(user).child("zipCode").setValue(zipcode)
        ref.child("users").child(user).child("country").setValue(country)
        ref.child("users").child(user).child("state").setValue(state)
        ref.child("users").child(user).child("address").setValue("\(country), \(state) \(zipcode)")
        ref.child("users").child(user).child("street").setValue("\(address)")
        
        // Send other default infos
        let days = ["monday", "tuesday", "wednesday", "friday", "thursday", "saturday", "sunday", "mondayAm", "tuesdayAm", "wednesdayAm", "fridayAm", "thursdayAm", "saturdayAm", "sundayAm"]
        
        for n in 0...13 {
            ref.child("users").child(user).child("availability").child(days[n]).setValue(true)
        }
        
        ref.child("users").child(user).child("mark").setValue(0)
        ref.child("users").child(user).child("totalHelps").setValue(0)
        ref.child("users").child(user).child("rates").setValue(0)
        
        print("Data sent: account successfuly created!")
    }

}
