//
//  Factory.swift
//  Pods
//
//  Created by Carlos David Rios Vertel on 8/11/16.
//
//

import Foundation
import ObjectMapper

/// Intances of this class manage storage of data using localfiles
public final class Factory {
    
    //TODO: try to remove this method returns an optional
    internal class func build<T: Mappable>(_ filePath: String) -> [T]? {
        let url = URL(fileURLWithPath: filePath)
        
        if let str = try? NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) {
            
            let data: Data = str.data(using: String.Encoding.utf8.rawValue)!
            let dict: AnyObject? = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as AnyObject?
            return Mapper<T>().mapArray(JSONArray: dict as! [[String: Any]])
        }
        
        return .none
    }

    internal class func build<T: Mappable>(_ filePath: String) -> T? {
        let url = URL(fileURLWithPath: filePath)
        
        if let str = try? NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) {
            return Mapper<T>().map(JSONString: str as String)
        }
        
        return .none
    }
    
}
