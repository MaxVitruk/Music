//
//  Network.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Foundation
import Alamofire

//Namespace

public protocol Executor {
    associatedtype RequestLink : Hashable
    func execute<T : Endpoint>(endpoint : T, _ block: @escaping (Network<Self>.Response<T.Target>) -> ()) -> RequestLink
    func cancel(request : RequestLink)
}

public class Network<T : Executor> {
    private var executor : T
    
    var requests : [URL : T.RequestLink] = [:]
    
    init(executor : T) {
        self.executor = executor
    }
}

public typealias Parameters = [String : Any]


extension Network {
    func requestUser(_ block : @escaping (Network.Response<[User]>) -> Void) {
        let endpoint = UserRequest()
    
        if let activeRequest = requests[endpoint.url] {
            executor.cancel(request: activeRequest)
        }
        
        let request = executor.execute(endpoint: endpoint) { [weak self] result in
            self?.requests.removeValue(forKey: endpoint.url)
            block(result)
        }
        
        requests[endpoint.url] = request
    }
}

