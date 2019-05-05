//
//  UIViewController+ErrorPresentation.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

struct ErrorUpdate {
    enum RefreshType {
        case swipe
        case tap
        case none
        case action(String, ()->Void)
        case custom(String)
        
        var message : String {
            switch self {
            case .swipe: return "Please swipe to refresh data"
            case .tap: return "Please tap to refresh"
            case .none: return "Please try again later"
            case .action: return ""
            case .custom(let text): return text
            }
        }
    }
}

protocol ErrorPopUpHolder {
    func showError(error : Error, refreshType : ErrorUpdate.RefreshType)
}

extension UIViewController : ErrorPopUpHolder {
    
    func showError(error : Error, refreshType : ErrorUpdate.RefreshType = .none){
        let alert = UIAlertController(title: "Oops ;(", message: "Error occured. \(refreshType.message)", preferredStyle: .alert)
        
        switch refreshType {
        case .action(let title, let action):
            alert.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                action()
            }))
        default:
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
