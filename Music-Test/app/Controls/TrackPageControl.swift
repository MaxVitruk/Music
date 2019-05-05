//
//  TrackPageController.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Foundation

protocol TrackPageControllerDelegate : class {
    func request(page : Int)
}

@objc
class TrackPageControl : NSObject {
    enum PageState {
        case loading(Int)
        case ready(Int)
        
        @discardableResult
        mutating func next() -> Bool {
            if case .ready(let page) = self {
                self = .loading(page + 1)
                return true
            }
            
            return false
        }
        
        mutating func done(){
            if case .loading(let page) = self {
                self = .ready(page)
            }
        }
        
        func unwarap() -> Int {
            switch self {
            case .ready(let value): return value
            case .loading(let value): return value
            }
        }
    }
    
    private var page : PageState = .ready(0) {
        didSet{
            if case .loading = page {
                isLoading = true
            }else{
                isLoading = false
            }
        }
    }
    
    @objc dynamic var isLoading : Bool = false
    
    var pageNumber : Int {
        return page.unwarap()
    }
    
    weak var delegate : TrackPageControllerDelegate?
    
    func requestNext(){
        if page.next() {
            delegate?.request(page: page.unwarap())
        }
    }
    
    func done(){
        page.done()
    }
}
