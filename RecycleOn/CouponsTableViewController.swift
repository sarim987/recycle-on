//
//  CouponsTableViewController.swift
//  RecycleOn
//
//  Created by Aristotel Fani on 12/3/18.
//  Copyright © 2018 SAKT. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CouponsTableViewController: UITableViewController {
    
    var coupons: [Coupons] = [Coupons(name: "Subway - $1 Off", points: 300, image: "subway", redeemed: false),
                              Coupons(name: "Dunkin Donuts - Free Donut", points: 400, image: "dunkin" , redeemed: false),
                              Coupons(name: "Starbucks - 15% Off", points: 600, image: "starbucks" , redeemed: false),
                              Coupons(name: "Footlocker - Free Socks", points: 800, image: "footlocker" , redeemed: false),
                              Coupons(name: "Walmart - $5 Off", points: 1200, image: "walmart" , redeemed: false) ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
            if snapshot.exists() {
                if let points = snapshot.childSnapshot(forPath: "points").value as? Int {
                    currentPoints = points
                }
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coupons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard coupons[indexPath.row].redeemed == false else { return UITableViewCell() }
        cell.textLabel?.text = coupons[indexPath.row].name
        cell.detailTextLabel?.text = "Redeem For \(coupons[indexPath.row].points) Points"
//        cell.detailTextLabel?.textColor = .blue
        cell.imageView?.image = UIImage(named: coupons[indexPath.row].image)

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard currentPoints > coupons[indexPath.row].points else {
            createAlertController(title: "Not Enough Points!", message: "You need \(coupons[indexPath.row].points - currentPoints) more points to redeem", image: "error")
            return
        }
        createAlertController(title: "Reedem This Coupon", message: "Hooray", image: "barcode", subtractPoints: coupons[indexPath.row].points)
        coupons.remove(at: indexPath.row)
        tableView.reloadData()
    }

    

}
