//
//  FactoryStrategy.swift
//  Pods
//
//  Created by Carlos David Rios Vertel on 8/11/16.
//
//

import Foundation
import ObjectMapper

/// Instace of Factory help get data from local files
open class FactoryStrategy: PersistenceStrategy {

    /**
     Creates a new empty instance of `FactoryStrategy`
     */
    public init() {}

    /**
     Get data from a local file and call a block with results
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    open func getData<T: Mappable>(_ accessObject: AccessObjectStrategy<[T]>, success: ([T]) -> Void, failure: (PMError) -> Void) {
        let str = accessObject.urlPath.url?.absoluteString
        let result: [T]? = Factory.build(str!)

        if let r = result {
            success(r)
        } else {
            failure(PMError.localStorageFailure(msg: "File not found"))
        }
    }

    /**
     Get data from a local file and call a block with results
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    open func getData<T: Mappable>(_ accessObject: AccessObjectStrategy<T>, success: (T) -> Void, failure: (PMError) -> Void) {
        let str = accessObject.urlPath.url?.absoluteString
        let result: T? = Factory.build(str!)
        
        if let r = result {
            success(r)
        } else {
            failure(PMError.localStorageFailure(msg: "Imposible to find the file"))
        }
    }
    
    
}
