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

enum AppDataErrors: Error {
    case URLCreationError
}

extension AppDataErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .URLCreationError:
            return "Error creating URL"
        }
    }
}

class AppData: ObservableObject {
    
    static let shared = AppData()
    
    @Published var books: [Book] = [Book]()
    @Published var updatedDate: Date? = nil
    @Published var isLoading: Bool = false
    
    let defaults = UserDefaults.standard
    static let sessionConfig = URLSessionConfiguration.ephemeral
    static let session = URLSession(configuration: sessionConfig)
    
    init() {
        // 1. Fetch from local cache (if exists)
        self.loadFromDefaults()
        
        Task {
            do {

                // 2. Then refresh local cache from server
                print("Fetching manifest")
                guard let url = URL(string: "https://raw.githubusercontent.com/treetrum/wot-glossaries-data/main/manifest.json") else {
                    throw AppDataErrors.URLCreationError
                }

                DispatchQueue.main.async {
                    self.isLoading = true
                }

                let (data, _) = try await AppData.session.data(from: url)
                
                defaults.set(data, forKey: PersistenceKeys.Manifest.rawValue)
                let parsed = try JSONDecoder().decode(Manifest.self, from: data)
                
                for book in parsed.books {
                    print("Fetching book: \(book.name)")
                    guard let url = URL(string: "https://raw.githubusercontent.com/treetrum/wot-glossaries-data/main/\(book.data)") else {
                        throw AppDataErrors.URLCreationError
                    }
                    let (glossaryData, _) = try await AppData.session.data(from: url)
                    defaults.set(glossaryData, forKey: book.data)
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }

                print("Setting updated date")
                defaults.set(Date.now, forKey: PersistenceKeys.UpdatedDate.rawValue)
                
                // 3. Update in memory with freshly fetched
                DispatchQueue.main.async {
                    self.loadFromDefaults()
                }
                
            } catch {
                DispatchQueue.main.async {
                    print("Failed to fetch images: \(error.localizedDescription)")
                    self.isLoading = false
                }
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

