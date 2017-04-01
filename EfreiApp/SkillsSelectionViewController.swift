//
//  SkillsSelectionViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 07/03/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class SkillsSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let reuseIdentifier = "cell"
    var items = ["Info", "Francais", "Maths", "Travaux", "Ménage"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.maxX * 0.293333333333333, height: UIScreen.main.bounds.maxY * 0.164917541229385)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SkillCollectionViewCell
        cell.layer.cornerRadius = cell.frame.size.width / 2
        cell.clipsToBounds = true
        cell.layer.borderWidth = 4
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.label.text = self.items[indexPath.item]
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell: \(indexPath.item)")
    }

    @IBAction func skipButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC")
        self.present(vc!, animated: true, completion: nil)
    }
    
}
