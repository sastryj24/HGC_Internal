//
//  pokemon.swift
//  Pokedex
//
//  Created by user161027 on 11/16/19.
//  Copyright © 2019 CS50. All rights reserved.
//

import Foundation

struct loginKey: Codable {
    let stateToken: String
}

struct outside: Codable {
    let data: allPieces
}

struct allPieces: Codable {
    var piece: [work]
}

struct work: Codable {
    var title: String!
    var url: String
    var performances: Int!
}

struct outsidePerforms: Codable {
    let data: performs
}

struct performs: Codable {
    let collection: [subwork]!
}

struct subwork: Codable {
    var stitle: String!
    var suburl: String!
    var artist: String!
    var album: String!
    var year: String!
    var downloadurl: String!
    var nodeurl: String!
}



