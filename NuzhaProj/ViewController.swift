//
//  ViewController.swift
//  NuzhaProj
//
//  Created by Mims on 27/09/1440 AH.
//  Copyright © 1440 Mims. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController,UICollectionViewDelegate ,UICollectionViewDataSource {

    @IBOutlet var myView: UIView!
    var CityList = Array<CityItem>()
    @IBOutlet weak var CollectionViewList: UICollectionView!
    
    
    @IBOutlet weak var SettImg: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        ReadFromPList();
        //
        view.setGradientBackground(colorOne: Colors.darkpurple, colorTwo: Colors.green)
        if myView != nil{
       myView.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
        }
    }
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        Cell.LaName.text = CityList[indexPath.row].Name!
        Cell.LaImage.image = UIImage(named: CityList[indexPath.row].Image!)
        //////UI (Design of collection view cell)
        Cell.contentView.layer.cornerRadius = 50
        Cell.contentView.layer.borderWidth = 1.0
        
        Cell.contentView.layer.borderColor = UIColor.clear.cgColor
        Cell.contentView.layer.masksToBounds = true
        
        Cell.LaName.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        Cell.LaName.textColor = .black
        /////// End of design
        return Cell
    }
    
    // to select the chosen item (to send it)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailes", sender: CityList[indexPath.row])
    }
    ///this func to send the chosen value to another view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dis = segue.destination as? ViewController2{
            if let City1 = sender as? CityItem {
                dis.SingleItem = City1
            }
        }
    }
    
    func ReadFromPList(){
        let path = Bundle.main.path(forResource: "Cities", ofType: "plist")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let plist = try! PropertyListSerialization.propertyList(from: data,options : .mutableContainers, format: nil)
        let dicArray = plist as! [[String:String]]
        for dic in dicArray{
            CityList.append(CityItem(Name: dic["Name"]!,
                                     Image: dic["Image"]!))
        }
    }

}


