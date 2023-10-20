//
//  Json.swift
//  TaskManager
//
//  Created by 张鸿燊 on 5/10/2023.
//

import Foundation


class JsonUtils {
    // 编码对象为 JSON 数据
    static private let encoder = JSONEncoder()
    static private let decoder = JSONDecoder()
    
    static func encode<T: Encodable>(_ object: T) -> String? {
        do {
            let jsonData = try encoder.encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error encoding JSON: \(error)")
            return nil
        }
        return nil
    }
    
    // 解码 JSON 数据为对象
    static func decode<T: Decodable>(_ type: T.Type, from jsonString: String) -> T? {
        if let jsonData = jsonString.data(using: .utf8) {
            
            do {
                let decodedObject = try decoder.decode(type, from: jsonData)
                return decodedObject
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        return nil
    }
}
