//
//  ViewController2.swift
//  NuzhaProj
//
//  Created by Mims on 19/06/2019.
//  Copyright © 2019 Mims. All rights reserved.
//
//App ID: ca-app-pub-7816505849077489~8347774091
//unit ID:ca-app-pub-7816505849077489/2211996185

import UIKit
import FirebaseFirestore
import GoogleMobileAds
class ViewController2: ViewController ,UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var imageChange: UIImageView!
    //Back button
    @IBAction func Labac(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var bannerview: GADBannerView!
    @IBOutlet var Myview2: UIView!
    @IBOutlet weak var TableViewList1: UITableView!
    var SingleItem : CityItem?
    var CitiesInRegion = [String]()
    var CitiesInRegionAfter = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // ReloadCityData()
        LoadFromDB()
        view.setGradientBackground(colorOne: Colors.darkpurple, colorTwo: Colors.green)
        if Myview2 != nil{
            Myview2.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
            // banner
            bannerview.adUnitID = "ca-app-pub-7816505849077489/2211996185"
            bannerview.rootViewController = self
            bannerview.load(GADRequest())
            bannerview.delegate = self
            //End banner
            
        }

        ///No line between cell
        TableViewList1.tableFooterView = UIView(frame: CGRect(x: 10, y: 100, width: 100, height: 80))
        //height for each cells(size)
        TableViewList1.rowHeight = 60.0
        TableViewList1.layer.borderColor = UIColor.clear.cgColor
        //image above
        imageChange.image = UIImage(named: SingleItem!.Image!)
        self.imageChange.layer.borderWidth = 3.0
        self.imageChange.layer.cornerRadius = 20.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CitiesInRegionAfter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let List = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        List.textLabel?.text = CitiesInRegionAfter[indexPath.row]
        //UI (Design of tableview cell)
        List.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        List.layer.borderColor = UIColor.clear.cgColor
        List.layer.borderWidth = 1.0
        List.layer.cornerRadius = 20
        List.textLabel?.textAlignment = .center
        //End of Design
        return List
    }
    
    // to select the chosen item (to send it)
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCityDetailes", sender: CitiesInRegion[indexPath.row])
    }
    ///this func to send the chosen value to another view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? ViewController3 ,let indexPath = TableViewList1.indexPathForSelectedRow {
            dist.SelectedCity = CitiesInRegionAfter[indexPath.row]
        }
        }

    func LoadFromDB()  {
        let db = Firestore.firestore()
        db.collection("Place").whereField("region", isEqualTo: SingleItem?.Name).getDocuments { (snapshot, error) in
            if error != nil{
                print(error)
            }else{
                for doc in (snapshot?.documents)!{
                    
                    if  let name = doc.data()["city_name"] as? String{
                        self.CitiesInRegion += [name]
                    }
                }
                self.CitiesInRegionAfter = self.CitiesInRegion.removeDuplicates()
                self.TableViewList1.reloadData()
            }
        }
        self.TableViewList1.reloadData()
    }
}
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

///banner
extension ViewController2: GADBannerViewDelegate{
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("receved ad")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}
