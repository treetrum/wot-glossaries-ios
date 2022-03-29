//
//  ContentView.swift
//  Shared
//
//  Created by Samuel Davis on 29/3/2022.
//

import SwiftUI

struct BookGlossaryView: View {
    
    @State var query: String = ""
    
    var book: Book
    
    var body: some View {
        
        let entries = book.entries.filter { entry in
            if query == "" {
                return true
            }
            return entry.titleRaw.lowercased().contains(query.lowercased())
        }
        
        List {
            ForEach(entries) { entry in
                NavigationLink {
                    GlossaryEntryView(entry: entry)
                } label: {
                    Text(entry.title ?? entry.titleRaw)
                }
            }
        }
        .navigationTitle(book.title)
        .searchable(text: $query)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookGlossaryView(book: AppData.shared.books.first!)
        }
    }
}
