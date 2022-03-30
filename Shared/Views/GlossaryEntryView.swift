//
//  GlossaryEntryView.swift
//  wot-glossaries (iOS)
//
//  Created by Samuel Davis on 29/3/2022.
//

import SwiftUI

struct GlossaryEntryView: View {
    
    let entry: GlossaryEntry

    var body: some View {
        VStack {
            ScrollView {
                
                VStack {
                    VStack(spacing: 4) {
                        Text(entry.title ?? entry.titleRaw)
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if (entry.titlePhonetic != nil) {
                            Text(entry.titlePhonetic ?? "")
                                .italic()
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding([.top, .bottom])
                    
                    Text(entry.content)
                        .frame(maxWidth: .infinity, alignment: .leading)

                }
            }
            .padding([.leading, .trailing, .bottom])
            
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct GlossaryEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GlossaryEntryView(entry: MockData.shared.books.first!.entries.first!)
        }
    }
}
