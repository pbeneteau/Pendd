//
//  time.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 30/03/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import Foundation
import EventKit

class Time {
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate as Date
                event.endDate = endDate as Date
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    func isPast(date: String) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let dateToCompare: Date = dateFormatter.date(from: date)!
        
        let todayDate = Date()
        
        if dateToCompare.timeIntervalSince1970 < todayDate.timeIntervalSince1970 {
            
            return true
        }
        return false
    }
    
    func isToday(date: NSDate) -> Bool {
        return Calendar.current.isDateInToday(date as Date)
    }
    
    // Convert NSDate to String
    func convertDateToString(format: Int, dateToConvert : String, completionHandler: @escaping (_ date: String) -> ()) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let date: Date = dateFormatter.date(from: dateToConvert)!
        
        if format == 0 {
            
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            
        } else  if format == 1 {
            if isToday(date: date as NSDate) {
                completionHandler("TODAY")
                return
            } else {
                dateFormatter.dateFormat = "EEEE"
            }
        } else {
            dateFormatter.dateFormat = "EEEE dd, yyyy"
        }
        
        let dateString = dateFormatter.string(from: date)
        completionHandler(dateString)
    }
    
    // get time remaining before a Date
    func timeRemainingString(finishDate date:NSDate) -> String {
        let secondsFromNowToFinish = date.timeIntervalSinceNow
                
        var hours = Int(secondsFromNowToFinish / 3600)
        var days: Int = 0
        let minutes: Int = Int(secondsFromNowToFinish / 60)
        
        if hours > 24 {
            while (hours > 24) {
                hours = hours - 24
                days += 1
                return String(format: "%02d days", days)
            }
        } else if (hours < 24) && (hours > 1){
            return String(format: "%02d hours", hours)
        } else if (hours < 1) {
            return String(format: "%02d minutes", minutes)
        }
        
        return "not found"
    }
    
    func convertStringToDate(date: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateConverted = dateFormatter.date(from: date)!
        
        return dateConverted
    }
}
