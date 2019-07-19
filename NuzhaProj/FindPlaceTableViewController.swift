//
//  FindPlaceTableViewController.swift
//  NuzhaProj
//
//  Created by Mims on 08/07/2019.
//  Copyright © 2019 Mims. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
class FindPlaceTableViewController: UITableViewController,UISearchResultsUpdating{

    @IBOutlet var placeSearches: UITableView!
    @IBAction func StopSearch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var placeArraySend = [String]()
    var placeArray = [NSDictionary?]()
    var filterPlace = [NSDictionary?]()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        placeSearches.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "اكتب اسم المكان للبحث عنه !!!"
        //
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.black
        //
    loadfromDB()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text !=
            ""{
            return self.filterPlace.count
        }else{
            return self.placeArray.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let plac : NSDictionary?
        if searchController.isActive && searchController.searchBar.text != "" {
            plac = self.filterPlace[indexPath.row]
            cell.textLabel?.text = plac?["name"] as? String
            cell.detailTextLabel?.text = plac?["city_name"] as? String
            cell.textLabel?.textAlignment = .right
            return cell
        }else{
            plac = self.placeArray[indexPath.row]
            cell.textLabel?.text = plac?["name"] as? String
            cell.detailTextLabel?.text = plac?["city_name"] as? String
            cell.textLabel?.textAlignment = .right
            return cell
    }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPlaceDetailes2", sender: placeArraySend[indexPath.row])
    }
    ///this func to send the chosen value to another view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dist = segue.destination as? ViewController4 ,let indexPath = placeSearches.indexPathForSelectedRow {
            dist.SelectedPlace = placeArraySend[indexPath.row] as? String
        }
    }
        func updateSearchResults(for searchController: UISearchController) {
            filterContent(searchText:self.searchController.searchBar.text!)
            
        }
        
        func filterContent(searchText:String)  {
            self.filterPlace = self.placeArray.filter { place in
                let placename = place!["name"] as? String
                return (placename?.contains(searchText))!
            }
            placeSearches.reloadData()
        }
        func loadfromDB(){
            let db = Firestore.firestore()
            _ = db.collection("Place").getDocuments { (snapshot, error) in
                if error != nil{
                    print(error)
                }else{
                    for doc in (snapshot?.documents)!{
                        let nam = doc.data() as? NSDictionary
                        self.placeArray += [nam]
                        let placesended = doc.data()["name"] as! String
                        self.placeArraySend += [placesended]
                    }
                    self.placeSearches.reloadData()
                }
            }
        }
}
