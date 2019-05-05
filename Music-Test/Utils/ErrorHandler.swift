//
//  ErrorHandler.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

protocol ErrorHandler {
    func handleError(_ error : Error)
}

typealias TableData = TableDataHolder & UITableViewController

extension ErrorHandler where Self : TableData {
    func handleError(_ error : Error){
        if data.count > 0 {
            showError(error: error, refreshType: .swipe)
        }else{
            tableView.setNoData(reason: .error(error))
        }
    }
}
