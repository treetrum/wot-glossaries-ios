//
//  BookView.swift
//  wot-glossaries (iOS)
//
//  Created by Samuel Davis on 29/3/2022.
//

import SwiftUI

struct BookListView: View {
    var body: some View {
        List {
            ForEach(MockData.shared.books, id: \.title) { book in
                NavigationLink {
                    GlossaryView(book: book)
                } label: {
                    Text(book.title)
                }
            }
        }
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
