//
//  ViewController3.swift
//  NuzhaProj
//
//  Created by Mims on 23/06/2019.
//  Copyright © 2019 Mims. All rights reserved.
//

import UIKit
import FirebaseFirestore
class ViewController3: ViewController ,UITableViewDelegate ,UITableViewDataSource {
    
//mack change in each side of segment
    @IBAction func SegmentedChange(_ sender: Any) {
        TableViewListPlace.reloadData()
    }
    @IBOutlet weak var SegmentedCon: UISegmentedControl!
    @IBOutlet weak var TableViewListPlace: UITableView!
   var SelectedCity: String?
    var TouristPlace = [String]()
    var HoristicalPlace = [String]()

    @IBAction func LaBack2(_ sender: Any) {
                dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadFromDB()
        ///No line between cell
        TableViewListPlace.tableFooterView = UIView(frame: CGRect(x: 10, y: 100, width: 100, height: 80))
        //height for each cells(size)
        TableViewListPlace.rowHeight = 60.0
   }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SegmentedCon.selectedSegmentIndex {
        case 0:
            return HoristicalPlace.count
        case 1:
              return TouristPlace.count
        default:
          break
        }
        return 0
    }
    var Sel: String = ""
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let Place = tableView.dequeueReusableCell(withIdentifier: "Pcell", for: indexPath)

        switch SegmentedCon.selectedSegmentIndex {
        case 0:
           Place.textLabel?.text = HoristicalPlace[indexPath.row]
           ////UI (Design of tableview cell)
           Place.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
           Place.layer.borderColor = UIColor.clear.cgColor
           Place.layer.borderWidth = 1.0
           Place.layer.cornerRadius = 20
           Place.textLabel?.textAlignment = .center
            ////End of Design
               return Place
        case 1:
            Place.textLabel?.text = TouristPlace[indexPath.row]
            ////UI (Design of tableview cell)
            Place.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            Place.layer.borderColor = UIColor.clear.cgColor
            Place.layer.borderWidth = 1.0
            Place.layer.cornerRadius = 20
            Place.textLabel?.textAlignment = .center
            ////End of Designd
               return Place
        default:
            break
        }
             return Place
    }
var CI : String?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.CI = cell?.textLabel?.text
          performSegue(withIdentifier: "ShowPlaceDetailes", sender: CI)
    }
    
    //this func to send the chosen value to another view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? ViewController4 ,let indexPath = TableViewListPlace.indexPathForSelectedRow {
            dist.SelectedPlace = self.CI
        }
    }
    
    func LoadFromDB()  {
        let db = Firestore.firestore()
        db.collection("Place").whereField("city_name", isEqualTo: SelectedCity).getDocuments { (snapshot, error) in
            if error != nil{
                print(error)
            }else{
                for doc in (snapshot?.documents)!{
                    if  let name = doc.data()["city_name"] as? String{
                       // print(name)
                        let tpe = doc.data()["type"] as! String
                        let nma = doc.data()["name"] as! String
                        if tpe == "Historical" {
                            self.HoristicalPlace += [nma]
                    }
                        if tpe == "Tourist" {
                            self.TouristPlace += [nma]
                        }
                    }else {
                    }
                }
                self.TableViewListPlace.reloadData()
            }
        }
        self.TableViewListPlace.reloadData()
    }
}


