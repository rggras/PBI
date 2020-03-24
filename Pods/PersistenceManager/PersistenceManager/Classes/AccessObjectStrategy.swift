//
//  AccessObjectStrategy.swift
//  Pods
//
//  Created by Carlos David Rios Vertel on 8/9/16.
//
//

import Foundation

/**
 *  A type with a customized URLRequest representation
 */
public protocol URLRequestConvertible {
    /// The URL request.
    var urlPath: URLRequest { get set}
}

/// A type that encapsulates configuration strategy
public final class AccessObjectStrategy<T>: URLRequestConvertible {
    
    public var urlPath: URLRequest
    
    /**
     Creates a new  instance of `AccessObjectStrategy` with provided parameters
     
     - parameter URL: Source URLRequest
     */
    public init(URL: URLRequest) {
        self.urlPath = URL
    }
    
 /// Involved data
    public var data: T!
}
