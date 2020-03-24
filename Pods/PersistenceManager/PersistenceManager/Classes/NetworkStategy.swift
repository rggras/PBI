//
//  NetworkStategy.swift
//  Pods
//
//  Created by Carlos David Rios Vertel on 8/9/16.
//
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import BoltsSwift

/// Intances of this class manage storage of data using a web service
public final class NetworkStrategy: PersistenceStrategy {
    
    /// Alamofire instance
    public var alamofire = Alamofire.SessionManager()
    
    /**
     Creates a new empty instance of `NetworkStrategy`
     */
    public init() {}
    
    /**
     Get data from a web service and call a block with result
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func getData<T: Mappable>(_ accessObject: AccessObjectStrategy<[T]>, success: @escaping ([T]) -> Void, failure: @escaping (PMError) -> Void) {
        alamofire.request(accessObject.urlPath).validate().responseArray {
            (response: DataResponse<[T]>) in
            
            if response.result.isSuccess {
                let values = response.result.value!
                accessObject.data = values
                success(values)
            } else {
                var errorObj = PMError.requestFailure(error: response.error)
                if let error = response.error as? AFError {
                    errorObj = PMError.networkingFailure(error: error)
                }
                failure(errorObj)
            }
        }
    }

    
    /**
     Get a object from a web service and call a block with result
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func getData<T: Mappable>(_ accessObject: AccessObjectStrategy<T>, success: @escaping (T) -> Void, failure: @escaping (PMError) -> Void) {
        
        
        alamofire.request(accessObject.urlPath).validate().responseObject { (response: DataResponse<T>) in
            if response.result.isSuccess {
                let values = response.result.value!
                accessObject.data = values
                success(values)
            } else {
                var errorObj = PMError.requestFailure(error: response.error)
                if let error = response.error as? AFError {
                    errorObj = PMError.networkingFailure(error: error)
                }
                failure(errorObj)
            }
        }
    }
    
    
    /**
     Post data to a web service call a block with result
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func postData<T: Mappable>(_ accessObject: AccessObjectStrategy<[T]>, success: @escaping ([T]) -> Void, failure: @escaping (PMError) -> Void) {
        
        alamofire.request(accessObject.urlPath).validate().responseArray { (response: DataResponse<[T]>) in
            if response.result.isSuccess {
                let values = response.result.value!
                success(values)
            } else {
                var errorObj = PMError.requestFailure(error: response.error)
                if let error = response.error as? AFError {
                    errorObj = PMError.networkingFailure(error: error)
                }
                failure(errorObj)
            }
        }
    }

    /**
     Post a object to a web service and call a block with result
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func postData<T: Mappable>(_ accessObject: AccessObjectStrategy<T>, success: @escaping (T) -> Void, failure: @escaping (PMError) -> Void) {
        
        
        alamofire.request(accessObject.urlPath).validate().responseObject { (response: DataResponse<T>) in
            if response.result.isSuccess {
                let values = response.result.value!
                success(values)
            } else {
                var errorObj = PMError.requestFailure(error: response.error)
                if let error = response.error as? AFError {
                    errorObj = PMError.networkingFailure(error: error)
                }
                failure(errorObj)
            }
        }
    }
    
}

extension NetworkStrategy: PersistenceStrategyTask {
    
    /**
     Get data from a web service and return a `Task` with results
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     - @see https://github.com/BoltsFramework/Bolts-Swift.git
     */
    public func getData<T: Mappable>(_ accessObject: AccessObjectStrategy<[T]>) -> Task<[T]> {
        let sourceTask = TaskCompletionSource<[T]>()
        
        self.getData(accessObject, success: { (items: [T]) in
            sourceTask.set(result: items)
        }) { (error: PMError) in
            sourceTask.set(error: error)
        }
        
        return sourceTask.task
    }

    /**
     Get a object from a web service and return a `Task` with results
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     - @see https://github.com/BoltsFramework/Bolts-Swift.git
     */
    
    public func getData<T: Mappable>(_ accessObject: AccessObjectStrategy<T>) -> Task<T> {
        let sourceTask = TaskCompletionSource<T>()
        
        self.getData(accessObject, success: { (item: T) in
            sourceTask.set(result: item)
        }) { (error: PMError) in
            sourceTask.set(error: error)
        }
        
        return sourceTask.task
    }
    
    /**
     Post data to a web service and return a `Task` with results
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     - @see https://github.com/BoltsFramework/Bolts-Swift.git
     */
    public func postData<T: Mappable>(_ accessObject: AccessObjectStrategy<[T]>) -> Task<[T]> {
        
        let sourceTask = TaskCompletionSource<[T]>()
        
        self.postData(accessObject, success: { (items: [T]) in
            sourceTask.set(result: items)
        }) { (error: PMError) in
            sourceTask.set(error: error)
        }
        
        return sourceTask.task
    }
    

    /**
     Post a object to a web service and return a `Task` with results
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     - @see https://github.com/BoltsFramework/Bolts-Swift.git
     */
    public func postData<T: Mappable>(_ accessObject: AccessObjectStrategy<T>) -> Task<T> {
        
        let sourceTask = TaskCompletionSource<T>()
        
        self.postData(accessObject, success: { (item: T) in
            sourceTask.set(result: item)
        }) { (error: PMError) in
            sourceTask.set(error: error)
        }
        
        return sourceTask.task
    }
    
}
