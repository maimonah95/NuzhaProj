//
//  ViewController4.swift
//  NuzhaProj
//
//  Created by Mims on 03/07/2019.
//  Copyright © 2019 Mims. All rights reserved.
//
//App ID: ca-app-pub-7816505849077489~8347774091
//unit ID:ca-app-pub-7816505849077489/1555544157

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import MessageUI
import GoogleMobileAds
class ViewController4: ViewController ,UITableViewDelegate , UITableViewDataSource {

    
    @IBAction func LaBack(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var MainScroll: UIScrollView!
    @IBOutlet weak var PageCon: UIPageControl!
    @IBOutlet weak var TableViewList: UITableView!
    @IBOutlet weak var TextInfo: UITextView!
    @IBOutlet weak var bannerview2: GADBannerView!
    
    //
    var SelectedPlace: String?
    var DataList = [String]()
    var imgArray = [String]()
    var Frame = CGRect(x:0,y:0,width:0,height:0)
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadFromDBandStorage()
        ///No line between cell
        TableViewList.tableFooterView = UIView(frame: CGRect(x: 10, y: 100, width: 100, height: 80))
      
        //banner
        bannerview2.adUnitID = "ca-app-pub-7816505849077489/1555544157"
        bannerview2.rootViewController = self
        bannerview2.load(GADRequest())
        bannerview2.delegate = self
        //End banner
        //height for each cells(size)
        TableViewList.rowHeight = 60.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 let Place = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        Place.textLabel?.text = DataList[indexPath.row]
        ////UI (Design of tableview cell)
        Place.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        Place.layer.borderColor = UIColor.clear.cgColor
        Place.layer.borderWidth = 1.0
        Place.layer.cornerRadius = 20
        Place.textLabel?.textAlignment = .right
        ////End of Design
        return Place
    }
    func LoadFromDBandStorage(){
        let db = Firestore.firestore()
        db.collection("Place").whereField("name", isEqualTo:SelectedPlace ).getDocuments { (snapshot, error) in
            if error != nil{
                print(error)
            }else{
                for doc in (snapshot?.documents)!{
                    if  let family = doc.data()["Suitable_for_families"] as? Bool{
                        if family {
                            self.DataList += ["مناسب للعائلة-"]
                        } }
                    if  let Kids = doc.data()["Suitable_for_kids"] as? Bool{
                        if Kids {
                            self.DataList += ["مناسب للأطفال-"]
                        } }
                    if  let inf = doc.data()["info"] as? String{
                        if inf != nil {
                            self.TextInfo?.text = inf
                        } }
                    if  let food = doc.data()["Foods"] as? Bool{
                        if food {
                            self.DataList += ["اماكن للأكل-"]
                        } }
                    if let img = doc.data()["phot"] as? [String]{
                        self.imgArray += img
                    }
                }
                self.TableViewList.reloadData()
            }
            let StorRef = Storage.storage().reference(forURL: "gs://nuzhah-ae46d.appspot.com")
            for i in 0..<self.imgArray.count{
                let island = StorRef.child(self.imgArray[i])
                island.getData(maxSize: 8 * 1024 * 1024 ){ data , error in
                    if let error = error{
                        print(error)
                    } else {
                        self.PageCon.numberOfPages = self.imgArray.count
                        self.Frame.origin.x = self.MainScroll.frame.size.width * CGFloat(i)
                        self.Frame.size = self.MainScroll.frame.size
                        let imageview = UIImageView(frame:self.Frame)
                        imageview.image = UIImage(data: data!)
                        self.MainScroll.addSubview(imageview)
                    }
                    self.MainScroll.contentSize = CGSize(width:( self.MainScroll.frame.size.width * CGFloat(self.imgArray.count)), height: self.MainScroll.frame.size.height)
                    //
                    self.MainScroll.layer.borderWidth = 3.0
                    self.MainScroll.layer.cornerRadius = 20.0
                    self.MainScroll.delegate = self
                }
            }
    }
        self.TableViewList.reloadData()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNum = self.MainScroll.contentOffset.x / self.MainScroll.frame.size.width
        PageCon.currentPage = Int(pageNum)
    }

}
///banner
extension ViewController4: GADBannerViewDelegate{
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("receved ad")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}
