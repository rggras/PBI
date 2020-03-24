//
//  Error.swift
//  Pods
//
//  Created by Carlos David Rios Vertel on 8/9/16.
//
//

import Foundation
import Alamofire
import RealmSwift
import UIKit

public enum PMError: Swift.Error, CustomStringConvertible {
    
    case dataBaseFailure(error: Realm.Error.Code)
    case networkingFailure(error: AFError?)
    case requestFailure(error: Error?)
    case localStorageFailure(msg: String)
    case unknownFailure(msg: String)
    
    public var code: Int {
        switch (self){
        case .requestFailure(let e):
            if let err = e {
                return err._code
            }
            return 9999
        case .networkingFailure(let e):
            if let err = e {
                return err.responseCode!
            }
            return 9999
        default:
            return -9999
        }
    }
    
    public var description: String {
        
        switch (self){
        case .requestFailure(let e):
            if let err = e {
                return "Error: \(err.localizedDescription)"
            }
            return "unknown error"
        case .networkingFailure(let e):
            if let err = e {
                switch err {
                case .invalidURL(let url):
                    return "Not valid url \(url)"
                case .parameterEncodingFailed(let reason):
                    return "Bad parameters encodings - \(reason)"
                case .multipartEncodingFailed(let reason):
                    return "Bad parameters encodings - \(reason)"
                case .responseValidationFailed(let reason):
                    return "responseSerializationFailed - \(reason)"
                case .responseSerializationFailed(let reason):
                    return "responseSerializationFailed - \(reason)"
                }
            }
            return "unknown error"
            
        case .dataBaseFailure(let e):
            switch e {
            case .fail:
                return ""
            case .fileAccess:
                return ""
            case .filePermissionDenied:
                return ""
            case .fileExists:
                return ""
            case .fileNotFound:
                return ""
            case .incompatibleLockFile:
                return ""
            case .fileFormatUpgradeRequired:
                return ""
            case .addressSpaceExhausted:
                return ""
            case .schemaMismatch:
                return ""
            case .incompatibleSyncedFile:
                return ""
            }
        case .localStorageFailure(let msg):
            return msg
        case .unknownFailure(let msg):
            return msg
        }
    }
    
    
}
