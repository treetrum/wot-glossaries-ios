//
//  BookView.swift
//  wot-glossaries (iOS)
//
//  Created by Samuel Davis on 29/3/2022.
//

import SwiftUI

struct BookListView: View {
    
    @ObservedObject var appData = AppData.shared
    
    var body: some View {
        
        VStack {
            List {
                Section {
                    ForEach(AppData.shared.books, id: \.title) { book in
                        NavigationLink {
                            GlossaryView(book: book)
                        } label: {
                            Text(book.title)
                        }
                    }
                } footer: {
                    HStack(spacing: 8) {
                        if appData.isLoading {
                            ProgressView()
                        }
                        Text("Last updated: \(appData.updatedDate?.formatted() ?? "Never")")
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("The Wheel of Time")
        
        
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookListView()
        }
    }
}
