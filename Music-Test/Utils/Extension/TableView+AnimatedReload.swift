//
//  TableView+AnimatedReload.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadDataAnimated(animation : UITableView.RowAnimation = .automatic){
        let sections = IndexSet(integersIn: 0..<numberOfSections)
        self.reloadSections(sections, with: animation)
    }
}
