//
//  Network+Response.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Foundation
import Alamofire

extension Network {
    public enum Response<Value>{
        case success(Value)
        case failure(Swift.Error)
    }
}

extension AFResult {
    public func unwrap() throws -> Success {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
    var networking : Network<AlamofireExecutor>.Response<Success>{
        return Network.Response(value: unwrap).mapError{ $0 /* Specialise error if needed */}
    }
}


extension Network.Response {
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        return !self.isFailure
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return self.error != nil
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value): return value
        case .failure:            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:            return nil
        case .failure(let error): return error
        }
    }
    
    public init(value: () throws -> Value) {
        do { self = try .success(value()) }
        catch { self = .failure(error) }
    }
    
    func mapError<T: Error>(_ transform: (Error) -> T) -> Network.Response<Value> {
        switch self {
        case .success:            return self
        case .failure(let error): return .failure(transform(error))
        }
    }
}
