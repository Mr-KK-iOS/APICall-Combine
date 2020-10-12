//
//  ResponseModel.swift
//  Swift Publisher Test1
//
//  Created by Admin on 10/12/20.
//  Copyright © 2020 Kaustabh. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Codable, Identifiable {
    var id = UUID()
    let movieId: Int
    let originalTitle: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case originalTitle = "original_title"
        case title
    }
}


struct MyNote: Codable, Identifiable {
    let id = UUID()
    var title: String
    var url: String
    var thumbnailUrl: String

    static var placeholder: MyNote {
        return MyNote(title: "No Title", url: "", thumbnailUrl: "")
    }
}
