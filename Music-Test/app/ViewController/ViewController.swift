//
//  ViewController.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {
    
    private var userCellName : String { return "user_cell" }
    
    var users : [User] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.requestUser { result in
            switch result {
            case .success(let users):
                self.users = users.sorted(by: { $0.score > $1.score })
            case .failure(let error):
                print("Error = " + error.localizedDescription)
            }
        }
    }
}


//Mark: - Table View Datasource
extension UserViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellName) as! UserCell
        cell.set(user: user)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

