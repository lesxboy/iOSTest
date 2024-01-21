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
                Text("**Name:** \(characterModel.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("**Gender:** \(characterModel.gender)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("**Species:** \(characterModel.species)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("**Status:** \(characterModel.status)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .cornerRadius(12)
            Spacer()
        }.padding(12)
    }
}

#Preview {
    CharacterDetailView(characterModel: CharacterModel(id: 2, name: "Test name", status: "test", species: "tsst", type: "ts", gender: "tsts", origin: OriginModel(name: "", url: ""), location: LocationModel(name: "", url: ""), image: "", episode: [], url: "", created: ""))
}
