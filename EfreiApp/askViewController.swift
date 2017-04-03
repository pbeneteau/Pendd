//
//  askViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 24/02/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import SwiftLocation
import NVActivityIndicatorView
import DateTimePicker

class askViewController: keyboardUtils, UIPickerViewDelegate, UIPickerViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var taskPicker: UIPickerView!
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    
    
    // Variables
    var userAddress: String!
    var userStreet: String!
    var countryCode: String!
    var state: String!
    var userLocation: CLLocation!
    var homeLocation: CLLocation!
    var price: String!
    var taskSelected: String = ""
    var pickerData: [String] = [String]()
    var dateSelected: Date!
    var taskTitleString: String!
    var descriptionText: String!
    
    // Classes
    let locationClass = locationHelp()
    let AskClass = AskHelp()
    
    // Firebase
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        initLocationDetails()
        initTaskPicker()
        initMapView()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Keyboard init
        addObservers()
        setDelegates(priceField, taskDescription)
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
    
    override func viewDidAppear(_ animated: Bool) {
        stopAnimating()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initLocationDetails() {
        
        locationClass.setLocation { success in
            if success {
                self.locationClass.retrieveUserDatabaseAdress(userID: (self.user?.uid)!) { address in
                    self.locationClass.retrieveUserDatabaseStreet(userID: self.user!.uid) { street in
                        self.userAddress = address
                        self.userStreet = street
                        self.locationClass.coordinatesFromAdress(address: "\(self.userAddress!), \(self.userStreet!)") { location in
                            self.initInfos()
                        }
                    }
                }
            }
        }
    }
    
    func initInfos() {

        countryCode = locationClass.getCountryCode()
        state = locationClass.getState()
        userLocation = locationClass.getLocation()
        homeLocation = locationClass.getUserHomeLocation()
    }
    
    // Map view initialisation
    func initMapView() {
        mapView.setUserTrackingMode(.follow, animated: true)
        
        mapView.layer.cornerRadius = mapView.frame.size.width/2
        mapView.clipsToBounds = true
    }
    
    func initTaskPicker() {
        getTaskList { finished in
            if finished {
                self.taskPicker.reloadAllComponents()
            }
        }
    }
    
    // Task picker initialisation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.taskSelected = pickerData[row]
    }
    
    // Retrieve all tasks type from database
    func getTaskList(completionHandler: @escaping (_ tasks: Bool) -> ()) {
        
        let tasksRef = ref.child("tasks")
        tasksRef.observe(.value, with: {
            (snapshot) in
            for tasks in snapshot.children {
                self.pickerData.append((tasks as AnyObject).key)
            }
            completionHandler(true)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Submit task request
    func sumbitTaskRequest(price: String, task: String, date: Date, address : String, street: String, countryCode: String, state: String, descriptionText: String, title: String) {
        
        if (AskClass.checkUserLocationHome(currentLocation: userLocation, homeLocation: homeLocation) == true) {
            
            AskClass.sendData(price: price, task: task, date: date, address: address, street: street, countryCode: countryCode, state: state, userIsAtHome: true, descriptionText: descriptionText, title: title)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Wait!", message: "You are making a request but you are not at home!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {(alert:
                UIAlertAction!) in
                self.AskClass.sendData(price: price, task: task, date: date, address: address, street: street, countryCode: countryCode, state: state, userIsAtHome: false, descriptionText: descriptionText, title: title)
                let alert2 = UIAlertController(title: "Save to calendar?", message: "Wanna save this event to your calendar?", preferredStyle: UIAlertControllerStyle.alert)
                alert2.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: {(alert:
                    UIAlertAction!) in
                    print("Cancel pressed")
                }))
                alert2.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert:
                    UIAlertAction!) in
                    
                    print("Adding to calendar")
                    let calendar = NSCalendar.current
                    let hoursAddedDate = calendar.date(byAdding: .hour, value: 2, to: date)
                    Time().addEventToCalendar(title: task, description: address, startDate: date, endDate: hoursAddedDate!)
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alert2, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert:
                UIAlertAction!) in
                print("Cancel pressed")
            }))
            alert.addAction(UIAlertAction(title: "Add address", style: UIAlertActionStyle.default, handler: {(alert:
                UIAlertAction!) in
                print("New address")
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func helpButton(_ sender: Any) {
        
        price = priceField.text
        descriptionText = taskDescription.text
        taskTitleString = taskTitle.text
        
        if checkNilValues() == true {
            
            sumbitTaskRequest(price: price, task: taskSelected, date: dateSelected, address: userAddress, street: userStreet, countryCode: countryCode, state: state, descriptionText: descriptionText, title: taskTitleString)
        }
    }
    
    // Exit button
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkNilValues() -> Bool{
        
        let array = [userAddress, countryCode, state, taskSelected, price, taskTitleString, descriptionText, "\(userLocation)", "\(homeLocation)", "\(taskSelected)", "\(dateSelected)", userStreet]
        
        for object in array {
            
            if object == nil || object == "" {
                print(object! as Any)
                print("fill out all values!")
                return false
            } else {
                print(object! as Any)
            }
        }
        return true
    }
    
    ///////////////////////////////////////////////
    @IBAction func datePicker(_ sender: Any) {
        dismissKeyboard()
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
        picker.completionHandler = { date in
            self.dateSelected = picker.selectedDate
        }
    }
    
    
    
}
