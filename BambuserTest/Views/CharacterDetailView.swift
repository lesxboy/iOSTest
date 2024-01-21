//
//  CharacterDetailView.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import SwiftUI

struct CharacterDetailView: View {
    
    let characterModel: CharacterModel
    
    var body: some View {
        VStack {
            AsyncImage(url:  URL(string: characterModel.image)) { image in
                image.resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "photo")
                    .frame(width: 200, height: 200)
                    .imageScale(.large)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
            }
            VStack {
                Text("**Gender:** \(characterModel.gender)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("**Species:** \(characterModel.species)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("**Status:** \(characterModel.status)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("**Origin:** \(characterModel.origin.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .cornerRadius(12)
            Spacer()
        }.padding(12)
            .navigationTitle(characterModel.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CharacterDetailView(characterModel: CharacterModel(id: 2, name: "Summer Smith", status: "Alive", species: "Human", type: "ts", gender: "Female", origin: OriginModel(name: "Earth (Replacement Dimension)", url: ""), location: LocationModel(name: "", url: ""), image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg", episode: [], url: "", created: ""))
}
