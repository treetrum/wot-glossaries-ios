//
//  AppData.swift
//  WoT Glossaries (iOS)
//
//  Created by Samuel Davis on 30/3/2022.
//

import Foundation

enum PersistenceKeys: String {
    case Manifest
    case UpdatedDate
}

class AppData: ObservableObject {
    
    static let shared = AppData()
    
    @Published var books: [Book] = [Book]()
    @Published var updatedDate: Date? = nil
    
    let defaults = UserDefaults.standard
    
    init() {
        // 1. Fetch from local cache (if exists)
        self.loadFromDefaults()
        
        Task {
            do {
                
                // 2. Then refresh local cache from server
                guard let url = URL(string: "https://raw.githubusercontent.com/treetrum/wot-glossaries-data/main/manifest.json") else {
                    fatalError("Error creating URL")
                }
                let (data, _) = try await URLSession.shared.data(from: url)
                
                defaults.set(data, forKey: PersistenceKeys.Manifest.rawValue)
                let parsed = try JSONDecoder().decode(Manifest.self, from: data)
                
                for book in parsed.books {
                    guard let url = URL(string: "https://raw.githubusercontent.com/treetrum/wot-glossaries-data/main/\(book.data)") else {
                        fatalError("Error creating URL")
                    }
                    let (glossaryData, _) = try await URLSession.shared.data(from: url)
                    defaults.set(glossaryData, forKey: book.data)
                }
                
                defaults.set(Date.now, forKey: PersistenceKeys.UpdatedDate.rawValue)
                
                // 3. Update in memory with freshly fetched
                self.loadFromDefaults()
                
            } catch {
                // TODO: Proper error handling
                fatalError("Error fetching up to date data")
            }
            
        }
    }
    
    func loadFromDefaults() {
        if let data = defaults.data(forKey: PersistenceKeys.Manifest.rawValue) {
            print("Loading from defaults")
            do {
                let parsed = try JSONDecoder().decode(Manifest.self, from: data)
                var tmpBooks = [Book]()
                for book in parsed.books {
                    if let glossaryData = defaults.data(forKey: book.data) {
                        let parsedGlossaryData = try JSONDecoder().decode(BookGlossary.self, from: glossaryData)
                        tmpBooks.append(Book(title: book.name, entries: parsedGlossaryData))
                    }
                }
                self.books = tmpBooks
                self.updatedDate = defaults.object(forKey: PersistenceKeys.UpdatedDate.rawValue) as? Date
            } catch {
                return
            }
        }
    }
}

