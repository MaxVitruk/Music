//
//  Support.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Foundation

func asyncMain(_ block : @escaping ()->Void) {
    DispatchQueue.main.async {
        block()
    }
}
