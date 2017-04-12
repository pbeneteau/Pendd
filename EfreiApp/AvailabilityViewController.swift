//
//  AvailabilityViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 04/03/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import M13Checkbox
import Firebase
import InteractiveSideMenu

class AvailabilityViewController: MenuItemContentViewController {
    
    @IBOutlet weak var Monday: M13Checkbox!
    @IBOutlet weak var Tuesday: M13Checkbox!
    @IBOutlet weak var Wednesday: M13Checkbox!
    @IBOutlet weak var Thursday: M13Checkbox!
    @IBOutlet weak var Friday: M13Checkbox!
    @IBOutlet weak var Saturday: M13Checkbox!
    @IBOutlet weak var Sunday: M13Checkbox!
    @IBOutlet weak var MondayAm: M13Checkbox!
    @IBOutlet weak var TuesdayAm: M13Checkbox!
    @IBOutlet weak var WednesdayAm: M13Checkbox!
    @IBOutlet weak var ThursdayAm: M13Checkbox!
    @IBOutlet weak var FridayAm: M13Checkbox!
    @IBOutlet weak var SaturdayAm: M13Checkbox!
    @IBOutlet weak var SundayAm: M13Checkbox!
    
    
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    private var availabilityDays: [String : Bool]!
    private var checkBoxes: [M13Checkbox]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAvailability()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //fillCheckBoxesWithData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func fillCheckBoxesWithData() {
       
        for (day, state) in availabilityDays {
            switch day {
            case "monday":
                if state == true {
                    Monday.setCheckState(.checked, animated: true)}
                break
            case "tuesday":
                if state == true {
                    Tuesday.setCheckState(.checked, animated: true)}
                
                break
            case "wednesday":
                if state == true {
                    Wednesday.setCheckState(.checked, animated: true)}
                break
            case "thursday":
                if state == true {
                    Thursday.setCheckState(.checked, animated: true)}
                break
            case "friday":
                if state == true {
                    Friday.setCheckState(.checked, animated: true)}
                break
            case "saturday":
                if state == true {
                    Saturday.setCheckState(.checked, animated: true)}
                break
            case "sunday":
                if state == true {
                    Sunday.setCheckState(.checked, animated: true)}
                break
            case "mondayAm":
                if state == true {
                    MondayAm.setCheckState(.checked, animated: true)}
                break
            case "tuesdayAm":
                if state == true {
                    TuesdayAm.setCheckState(.checked, animated: true)}
                
                break
            case "wednesdayAm":
                if state == true {
                    WednesdayAm.setCheckState(.checked, animated: true)}
                break
            case "thursdayAm":
                if state == true {
                    ThursdayAm.setCheckState(.checked, animated: true)}
                break
            case "fridayAm":
                if state == true {
                    FridayAm.setCheckState(.checked, animated: true)}
                break
            case "saturdayAm":
                if state == true {
                    SaturdayAm.setCheckState(.checked, animated: true)}
                break
            case "sundayAm":
                if state == true {
                    SundayAm.setCheckState(.checked, animated: true)}
            default: break
            }
        }
    }
    
    func initAvailability() {
        
        let userRef = ref.child("users").child((user?.uid)!).child("availability")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            
            if let dict = snapshot.value as? [String : Bool] {
                self.availabilityDays = dict
            }
        })
    }
    
    func sendData(){
        
        let days = ["monday", "tuesday", "wednesday", "friday", "thursday", "saturday", "sunday", "mondayAm", "tuesdayAm", "wednesdayAm", "fridayAm", "thursdayAm", "saturdayAm", "sundayAm"]
        var n = 0
        
        let monday = Monday.checkState
        let tuesday = Tuesday.checkState
        let wednesday = Wednesday.checkState
        let friday = Friday.checkState
        let thursday = Thursday.checkState
        let saturday = Saturday.checkState
        let sunday = Sunday.checkState
        let mondayAm = MondayAm.checkState
        let tuesdayAm = TuesdayAm.checkState
        let wednesdayAm = WednesdayAm.checkState
        let fridayAm = FridayAm.checkState
        let thursdayAm = ThursdayAm.checkState
        let saturdayAm = SaturdayAm.checkState
        let sundayAm = SundayAm.checkState
        
        let states = [monday, tuesday, wednesday, friday, thursday, saturday, sunday, mondayAm, tuesdayAm, wednesdayAm, fridayAm, thursdayAm, saturdayAm, sundayAm]
        
        for object in states {
            let state = "\(object)"
            var BoolState: Bool
            if state == "unchecked" {BoolState = false} else { BoolState = true}
            
            ref.child("users").child((user?.uid)!).child("availability").child(days[n]).setValue(BoolState)
            n += 1
        }
        print("Data sent")
        
    }
    @IBAction func setButton(_ sender: Any) {
        sendData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButton(_ sender: Any) {
        showMenu()
    }
}
