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
        self.requestAny(endpoint: endpoint, block)
    }
    
    func requestTracks(page : Int, limit : Int = 20, _ block : @escaping (Network.Response<[Track]>) -> Void) {
        let params = ["_page" : page, "_limit" : limit]
        let endpoint = AllTrucksRequest(params: params)
        self.requestAny(endpoint: endpoint, block)
    }
    
    @discardableResult
    func requestSingleTrack(id : String, _ block : @escaping (Network.Response<Track>) -> Void) -> URL {
        let endpoint = TruckRequest(params: [:], id: id)
        return self.requestAny(endpoint: endpoint, block)
    }
    
    func cancelRequest(for url : URL) {
        if let activeRequest = requests[url] {
            executor.cancel(request: activeRequest)
            requests.removeValue(forKey: url)
        }
    }
    
    @discardableResult
    private func requestAny<E : Endpoint>(endpoint : E, _ block: @escaping (Network<T>.Response<E.Target>) -> ()) -> URL {
        let url = endpoint.url
        cancelRequest(for: url)
        
        let request = executor.execute(endpoint: endpoint) { [weak self] result in
            self?.requests.removeValue(forKey: url)
            block(result)
        }
        
        requests[endpoint.url] = request
        
        return url
    }
}

