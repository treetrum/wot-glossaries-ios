//
//  Utils.swift
//  WoT Glossaries (iOS)
//
//  Created by Samuel Davis on 30/3/2022.
//

import Foundation

struct ModelUtils {
    static func decodeFromFileName<T : Codable>(_ fileName: String, decodable: T.Type) -> T {
        do {
            guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
                fatalError("No data file found: \(fileName)")
            }
            let fileUrl = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("\(error)")
        }
    }
}
