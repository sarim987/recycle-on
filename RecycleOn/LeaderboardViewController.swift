//
//  SecondViewController.swift
//  RecycleOn
//
//  Created by Sarim Ahmed on 11/26/18.
//  Copyright © 2018 SAKT. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LeaderboardViewController: UIViewController {
    
    var users:[User] = []
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.rowHeight = 75
        
        let db = Database.database().reference().child("users")
        db.observe(.value, with: { (data) in
            if data.exists() {
                
                if let dict = data.value as? NSDictionary {
                    self.getUsers(dict)
                }
            }
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getUsers(_ dict: NSDictionary) {
        users.removeAll(keepingCapacity: true)
        for d in dict {
            let data: [String: Any] = d.value as? [String: Any] ?? [:]
            let user = User(name: data["name"] as! String,
                            email: data["email"] as! String,
                            uid: data["uid"] as! String,
                            points: data["points"] as! Int,
                            image: data["name"] as! String)
            users.append(user)
        }
        users.sort { (u1, u2) -> Bool in u1.points > u2.points }
        tableview.reloadData()
    }

}

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = "\(users[indexPath.row].points) points"
        cell.imageView?.image = UIImage(named: users[indexPath.row].image) != nil ? UIImage(named: users[indexPath.row].image) : UIImage(named: "user_placeholder")
        return cell
    }
}

