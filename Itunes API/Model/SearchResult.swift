//
//  SearchResult.swift
//  Itunes API
//
//  Created by Iyin Raphael on 12/5/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    
    let title: String
    let creator: String
    
    enum CodingKeys: String, CodingKey {
        
        case title = "trackName"
        case creator = "artistName"
    }
}

struct SearchResults {
    
    var results: [SearchResult]
}
