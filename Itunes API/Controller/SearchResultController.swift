//
//  SearchResultController.swift
//  Itunes API
//
//  Created by Iyin Raphael on 12/5/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import Foundation

class SearchResultController {
    
    let baseURL = URL(fileURLWithPath: "https://itunes.apple.com/")
    
    var searchResults: [SearchResult] = []
    
    func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping (Error?) -> Void) {
        
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            fatalError("Unable to resolve baseURL to components")
        }
        let  searchQueryItem = URLQueryItem(name: "search", value: searchTerm)
        
        urlComponents.queryItems = [searchQueryItem]
        
        guard let searchURL = urlComponents.url else {
            NSLog("Error contructing search URL for \(searchTerm)")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: searchURL )
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil, let data = data else {
                if let error = error { // this will always succeed
                    NSLog("Error fetching data: \(error)")
                    completion(error) // we know that error is non-nil
                }
                return
            }
            
            do {
                
                let jsonDecoder = JSONDecoder()
                let searchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = searchResults.results
                completion(nil)
            } catch {
                NSLog("Unable to decode data into people: \(error)")
                completion(error)
            }
        }.resume()
    }
    
}
