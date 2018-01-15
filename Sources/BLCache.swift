//
//  BLCache.swift
//  Pods
//
//  Created by linhey on 2017/7/24.
//
//

import UIKit
import YYCache
import AnyFormatProtocol

public struct BLCache: AnyFormatProtocol {

  fileprivate static var docPath: String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first! + "/" + BLCache.name
  }

  fileprivate static var cachePath: String {
    return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true).first! + "/" + BLCache.name
  }

  fileprivate static var tmpPath: String {
    return NSTemporaryDirectory() + "/" + BLCache.name
  }

  public static var name = "org.cocoapods.BLCache"

  static let user = UserDefaults.standard
  static let cacheSql = YYCache(path: cachePath)
  static let docSql = YYCache(path: docPath)
  static let tmpSql = YYCache(path:tmpPath)

  public enum SQLState{
    case cache
    case tmp
    case doc
  }

  public enum State {
    case sql(SQLState)
    case userDefault
    case keychain
  }

  public static func set(name: String, value: Codable?, state: State) {
    guard let val = value else {
      switch state {
      case .sql(let type):
        switch type {
        case .cache: cacheSql?.removeObject(forKey: name)
        case .doc:   docSql?.removeObject(forKey: name)
        case .tmp:   tmpSql?.removeObject(forKey: name)
        }
      case .keychain:
        Keychain.deletePassword(service: name, account: name)
      case .userDefault: user.removeObject(forKey: name)
      }
      return
    }

    switch state {
    case .sql(let type):
      guard let code = val as? NSCoding else{
        fatalError("if use sqlite, value must be NSCoding")
      }
      switch type {
      case .cache: cacheSql?.setObject(code, forKey: name)
      case .doc:   docSql?.setObject(code, forKey: name)
      case .tmp:   tmpSql?.setObject(code, forKey: name)
      }
    case .keychain:
      Keychain.set(password: String(describing: val) , service: name, account: name)
    case .userDefault:
      user.set(value, forKey: name)
    }
  }

  public static func get<T: Codable>(name: String,default def: T, state: State) -> T {
    let object: Any?
    switch state {
    case .sql(let type):
      switch type {
      case .cache: object = cacheSql?.object(forKey: name)
      case .doc:   object = docSql?.object(forKey: name)
      case .tmp:   object = tmpSql?.object(forKey: name)
      }
    case .keychain:    object = Keychain.password(service: name, account: name)
    case .userDefault: object = user.object(forKey: name)
    }

    if object == nil { return def }

    guard let value = object as? T else {
      switch def {
      case let v as String:  return format(object, default: v) as? T ?? def
      case let v as CGFloat: return format(object, default: v) as? T ?? def
      case let v as Double:  return format(object, default: v) as? T ?? def
      case let v as Bool:    return format(object, default: v) as? T ?? def
      case let v as Int:     return format(object, default: v) as? T ?? def
      case let v as [Any]:   return format(object, default: v) as? T ?? def
      default:
        print("error: unfind value with name: \(name), and return default value: \(def)")
        return def
      }
    }
    return value
  }
}
