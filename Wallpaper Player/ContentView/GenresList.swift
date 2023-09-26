//
//  GenresList.swift
//  Wallpaper Player
//
//  Created by Haren on 2023/9/26.
//

import SwiftUI

struct GenresList: View {
    var body: some View {
        HSplitView {
            List {
                ForEach(0..<30, id: \.self) { i in
                    HStack {
                        Text("Hello, World!")
                        Text("\(i)")
                    }
                    .frame(height: 40)
                }
            }
            .listStyle(.plain)
            
            preview
        }
    }
    
    var preview: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Anime")
                    .font(.title)
                    .bold()
                Divider()
                HStack {
                    Text("84 ALBUMS, 445 SONGS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(nsColor: .scrubberTexturedBackground))
            .padding(.leading)
            .padding(.top, 50)
        }
    }
}

#Preview {
    GenresList()
}
