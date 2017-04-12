//
// NavigationMenuViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import InteractiveSideMenu

class NavigationMenuViewController: MenuViewController {

    let kItemsCount = 3
    let kCellReuseIdentifier = "UITableViewCell"
    
    @IBOutlet var tableView1: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView1.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
    }
}


extension NavigationMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! ProfileMenuTableViewCell
        
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            
            
            tableView.rowHeight = 195
            cell.contentView.frame.size.height = 195
            
            cell.menuIcon.isHidden = true
            cell.menuLabel.isHidden = true
            
            
            let profilePicture = UIImage(named: "ProfilePicture")
            let profilePictureView = UIImageView(image: profilePicture)
            profilePictureView.frame = CGRect(x:65, y:45, width:85, height:85)
            cell.contentView.addSubview(profilePictureView)
            
            let userNameLabel = UILabel(frame: CGRect(x:0, y:150, width: screenSize.width * 0.6, height:20))
            userNameLabel.text = "Jean-Pierre Bennaud"
            userNameLabel.textAlignment = .center
            userNameLabel.textColor = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.0)
            userNameLabel.font = UIFont(name: "Avenir-Heavy", size:16)
            cell.contentView.addSubview(userNameLabel)
            
            let lineView = UIView(frame: CGRect(x: cell.contentView.center.x * 0.6, y: cell.contentView.frame.maxY - 1, width: cell.contentView.frame.width * 0.3, height: 1))
            lineView.backgroundColor = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1.0)
            lineView.alpha = 0.2
            cell.contentView.addSubview(lineView)
            
            
//            for family: String in UIFont.familyNames
//            {
//                print("\(family)")
//                for names: String in UIFont.fontNames(forFamilyName: family)
//                {
//                    print("== \(names)")
//                }
//            }
            
            break
        case 1:
            
            tableView.rowHeight = 90
            cell.contentView.frame.size.height = 90
            
            break
        case 2:

            cell.menuIcon.image = UIImage(named: "ProfileMenuInformationsIcon")
            cell.menuLabel.text = "Informations"
            
            break
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let menuContainerViewController = self.menuContainerViewController else { return }
            menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
            menuContainerViewController.hideMenu()
        }
    }
}
