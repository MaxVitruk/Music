//
//  UserCell.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

class UserCell : UITableViewCell {
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var score : UILabel!
    
    func set(user : User){
        name.text = user.name
        score.text = user.score.description
    }
}
