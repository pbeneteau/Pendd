//
//  DeviceInfos.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 03/03/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class DeviceInfos {
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func isJailbroken() -> Bool {
        #if arch(i386) || arch(x86_64)
            // This is a Simulator not an idevice
            return false
        #else
            let fm = FileManager.default
            if(fm.fileExists(atPath: "/private/var/lib/apt")) {
                // This Device is jailbroken
                return true
            } else {
                // Continue the device is not jailbroken
                return false
            }
        #endif
    }
    
    func ExitOnJailbreak() {
        if isJailbroken() == true {
            print("You are running this app on a jailbroken iPhone")
            // Exit the app if Jailbroken
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
    }
}
