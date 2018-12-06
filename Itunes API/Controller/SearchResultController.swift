//
//  SearchResultController.swift
//  Itunes API
//
//  Created by Iyin Raphael on 12/5/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation

class SearchResultController {
    
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    
    var searchResults: [SearchResult] = []
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping ([SearchResult]?,Error?) -> Void) {
        
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Unable to resolve baseURL to components")
        }
        let  searchQueryItem = URLQueryItem(name: "term", value: searchTerm)
        let searchQueryType = URLQueryItem(name: "entity", value: resultType.rawValue)
        
        
        urlComponents.queryItems = [searchQueryItem, searchQueryType]
        
        guard let searchURL = urlComponents.url else {
            NSLog("Error contructing search URL for \(searchTerm)")
            completion(nil, NSError())
            return
        }
        
        var request = URLRequest(url: searchURL )
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil, let data = data else {
                if let error = error { // this will always succeed
                    NSLog("Error fetching data: \(error)")
                    completion(nil, error) // we know that error is non-nil
                }
                return
            }
            
            do {
                
                let jsonDecoder = JSONDecoder()
                let searchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = searchResults.results
                completion(self.searchResults, nil)
            } catch {
                NSLog("Unable to decode data into people: \(error)")
                completion(nil,error)
            }
        }.resume()
    }
    
}
