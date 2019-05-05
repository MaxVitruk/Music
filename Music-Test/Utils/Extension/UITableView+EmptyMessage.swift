//
//  UITableView+EmptyMessage.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

enum NoDataReason {
    case empty
    case loading
    case error(Error)
}

protocol EmptyMessageRepresentable {
    func setNoData(reason : NoDataReason)
    func setEmptyMessage(_ message: String)
    func removeEmptyMessage()
}

extension UITableView : EmptyMessageRepresentable {
    func setNoData(reason : NoDataReason){
        switch reason {
        case .empty:
            setEmptyMessage("No data for your request. ;(")
        case .loading:
            setEmptyMessage("Loading...")
        case .error(let e):
            setEmptyMessage("Oops. Error occured. \n \(e.localizedDescription)")
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let fullFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        let messageLabel = UILabel(frame: fullFrame)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.separatorStyle = .none
        self.backgroundView = messageLabel
    }
    
    func removeEmptyMessage() {
        self.separatorStyle = .singleLine
        self.backgroundView = nil
    }
}
