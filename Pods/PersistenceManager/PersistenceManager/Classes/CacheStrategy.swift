//
//  CacheStrategy.swift
//  Pods
//
//  Created by Carlos David Rios Vertel on 8/9/16.
//
//

import Foundation
import RealmSwift
import BoltsSwift

///Intances of this class manage a temporary storage of data
public final class CacheStrategy: PersistenceStrategy {
    
    /// Realm instance
    public var realm = try! Realm() // swiftlint:disable:this force_try
    
    /**
     Creates a new empty instance of `CacheStrategy`
     */
    public init () {}
    
    /**
     Get data from a local storage and call a block with result
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func getData<T: Object>(_ accessObject: AccessObjectStrategy<[T]>, success: ([T]) -> Void, failure: (PMError) -> Void) {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let array = Array(realm.objects(T.self))
        success(array)
    }
    
    /**
     Get a object from a local storage and call a block with result
     
     - parameter accessObjec: A configuration strategy object
     - parameter success:     Success block
     - parameter failure:     Failure block
     */
    public func getData<T: RealmSwift.Object>(_ accessObjec: AccessObjectStrategy<T>, success: (T) -> Void, failure: (PMError) -> Void) {
        let req = accessObjec.urlPath
        let d = req.allHTTPHeaderFields
        let _ = realm.object(ofType: T.self, forPrimaryKey: d!["objectId"]! as AnyObject)
    }
    
    /**
     Post data to a local storage call a block with result
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func postData<T: Object>(_ accessObject: AccessObjectStrategy<[T]>, success: ([T]) -> Void, failure: (PMError) -> Void) {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        let block = {
            self.realm.add(accessObject.data, update: true)
        }
        
        do {
            try self.realm.write(block)
            let array = Array(realm.objects(T.self))
            success(array)
            
            
        } catch let re as Realm.Error {
            let e = PMError.dataBaseFailure(error: re.code)
            failure(e)
        } catch {
            let e = PMError.unknownFailure(msg: "Unknown error")
            failure(e)
        }
        
    }
    
    
    /**
     Post an object to a local storage call a block with result
     
     - parameter accessObject: A configuration strategy object
     - parameter success:      Success block
     - parameter failure:      Failure block
     */
    public func postData<T: Object>(_ accessObject: AccessObjectStrategy<T>, success: (T) -> Void, failure: (PMError) -> Void) {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let block = {
            self.realm.add(accessObject.data, update: true)
        }
        
        do {
            try self.realm.write(block)
            let obj = realm.object(ofType: T.self, forPrimaryKey: accessObject.data[T.primaryKey()!])

            success(obj!)
            
        } catch let re as Realm.Error {
            let e = PMError.dataBaseFailure(error: re.code)
            failure(e)
        } catch {
            let e = PMError.unknownFailure(msg: "Unknown error")
            failure(e)
        }

        
    }
    
    
}

extension CacheStrategy : PersistenceStrategyTask {
    
    /**
     Get data from a local storage and return a `Task` with results
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     - @see https://github.com/BoltsFramework/Bolts-Swift.git
     */
    public func getData<T: Object>(_ accessObject: AccessObjectStrategy<[T]>) -> Task<[T]> {
        
        let taskSource = TaskCompletionSource<[T]>()
        
        self.getData(accessObject, success: { (items: [T]) in
            taskSource.set(result:items)
        }) { (e: PMError) in
            taskSource.set(error: e) }
        
        return taskSource.task
        
    }
    
    /**
     Get a object from a local storage and return a `Task` with results
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     - @see https://github.com/BoltsFramework/Bolts-Swift.git
     */
    public func getData<T: RealmSwift.Object>(_ accessObject: AccessObjectStrategy<T>) -> Task<T> {
        let taskSource = TaskCompletionSource<T>()
        
        self.getData(accessObject, success: { (item: T) in
            taskSource.set(result:item)
        }) { (e: PMError) in
            taskSource.set(error: e) }
        
        return taskSource.task
    }
    
    /**
     Post data to a local storage and return a `Task` with results
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     - @see https://github.com/BoltsFramework/Bolts-Swift.git
     */
    public func postData<T: Object>(_ accessObject: AccessObjectStrategy<[T]>) -> Task<[T]> {
        let task = TaskCompletionSource<[T]>()
        
        self.postData(accessObject, success: { (items: [T]) in
            task.set(result: items)
        }) { (error: PMError) in
            task.set(error: error)
        }
        
        return task.task
    }
    
    /**
     Post an object to a local storage call a block with result
     
     - parameter accessObject: A configuration strategy object
     - returns: An instance of `Task` with results.
     */
    public func postData<T: Object>(_ accessObject: AccessObjectStrategy<T>) -> Task<T> {
        let task = TaskCompletionSource<T>()
        
        self.postData(accessObject, success: { (item: T) in
            task.set(result: item)
        }) { (error: PMError) in
            task.set(error: error)
        }
        
        return task.task
    }
    
    
}
