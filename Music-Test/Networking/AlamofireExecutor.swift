//
//  AlamofireExecutor.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Alamofire


public struct AlamofireExecutor : Executor {
    public typealias AFE = AlamofireExecutor
    public typealias RequestLink = Request
    
    public func execute<T : Endpoint>(endpoint : T, _ block: @escaping (Network<AFE>.Response<T.Target>) -> ()) -> Request{
        return AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.params)
            .validate()
            .responseDecodable(queue: .global(qos: .userInitiated),
                               decoder: JSONDecoder(),
                               completionHandler: { (response: DataResponse<T.Target>) in
                block(response.result.networking)
            })
    }
    
    public func cancel(request: Request) {
        request.cancel()
    }
}
