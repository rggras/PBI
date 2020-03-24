//
//  PersistencyStrategy.swift
//  Pods
//
//  Created by Carlos David Rios Vertel on 8/9/16.
//
//

import Foundation
import BoltsSwift

/**
 *  Type that defines persistence methods
 */
public protocol PersistenceStrategy {
    /**
     Get data from a source
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    func getData<T>(_ accessObjec: AccessObjectStrategy<T>, success: ([T]) -> Void, failure: (PMError) -> Void)

    /**
     Get object data from a source
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    func getData<T>(_ accessObjec: AccessObjectStrategy<T>, success: (T) -> Void, failure: (PMError) -> Void)
    
    /**
     Post data from a source
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    func postData<T>(_ accessObject: AccessObjectStrategy<T>, success: ([T]) -> Void, failure: (PMError) -> Void)
}

/**
 *  Type that defines persistence methods
 */
public protocol PersistenceStrategyTask {

    /**
     Get data from a source and return a `Task` with result.
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     */
    func getData<T>(_ accessObject: AccessObjectStrategy<T>) -> Task<[T]>
    
    /**
     Get object data from a source and return a `Task` with result.
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     */
    func getData<T>(_ accessObject: AccessObjectStrategy<T>) -> Task<T>
    

    /**
     Post data from a source and return a `Task` with result.
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     */
    func postData<T>(_ accessObject: AccessObjectStrategy<T>) -> Task<[T]>
}

extension PersistenceStrategyTask {

    /**
     Default implementation for getData
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     */
    public func getData<T>(_ accessObject: AccessObjectStrategy<T>) -> Task<[T]> {
        assertionFailure("This is generic implementation. You must overload this method with your own implementation")
        return TaskCompletionSource<[T]>().task
    }
    
    /**
     Default implementation for getData
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     */
    public func getData<T>(_ accessObject: AccessObjectStrategy<T>) -> Task<T> {
        assertionFailure("This is generic implementation. You must overload this method with your own implementation")
        return TaskCompletionSource<T>().task
    }

    
    /**
     Default implementation for postData
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     */
    public func postData<T>(_ accessObject: AccessObjectStrategy<T>) -> Task<[T]> {
        assertionFailure("This is generic implementation. You must overload this method with your own implementation")
        return TaskCompletionSource<[T]>().task
    }
}


extension PersistenceStrategy {
    
    /**
     Default implementation for getData
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func getData<T>(_ accessObject: AccessObjectStrategy<T>, success: ([T]) -> Void, failure: (PMError) -> Void) {
        assertionFailure("This is generic implementation. You must define overload this method with your own implementation")
    }

    /**
     Default implementation for getData
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */    
    public func getData<T>(_ accessObject: AccessObjectStrategy<T>, success: (T) -> Void, failure: (PMError) -> Void) {
        assertionFailure("This is generic implementation. You must define overload this method with your own implementation")
    }
    
    /**
     Default implementation for postData
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func postData<T>(_ accessObject: AccessObjectStrategy<T>, success: ([T]) -> Void, failure: (PMError) -> Void) {
        assertionFailure("This is generic implementation. You must define overload this method with your own implementation")
    }
    
}
