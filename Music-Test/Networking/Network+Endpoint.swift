//
//  Endpoint.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Foundation
import Alamofire

public protocol Endpoint {
    associatedtype Target : Decodable
    var url : URL {get}
    var method : HTTPMethod { get }
    var params : Parameters { get set }
}

extension Network {
    public struct UserRequest : Endpoint {
        public typealias Target = [User]
        
        public var url: URL { return URL(string: "http://lc.playlist.com:3002/top_users/")! }
        public var method: HTTPMethod { return .get }
        
        public var params: [String : Any] = [:]
    }
    
    public struct TruckRequest : Endpoint {
        public typealias Target = [Track]
        
        public var url: URL { return URL(string: "http://lc.playlist.com:3001/tracks/")! }
        public var method: HTTPMethod { return .get }
        
        public var params: [String : Any]
    }
}
