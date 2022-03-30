//
//  ContentView.swift
//  Shared
//
//  Created by Samuel Davis on 29/3/2022.
//

import SwiftUI

struct GlossaryView: View {
    
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
                    VStack(alignment: .leading, spacing: 0) {
                        Text(entry.title ?? entry.titleRaw)
                        if let titlePhonetic = entry.titlePhonetic {
                            Text(titlePhonetic)
                                .font(.caption)
                                .italic()
                                .opacity(0.75)
                        }
                    }.padding([.top, .bottom], 2)
                    
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(book.title)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GlossaryView(book: MockData.books.first!)
        }
    }
}
