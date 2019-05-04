//
//  User.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Foundation

public struct User : Codable, Equatable {
    let id : String
    let name : String
    let score : Int
}
