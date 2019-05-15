//
//  APIService.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/7/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit


//Networking layer should be seperated of viewController

//this class to perform network fetches for podcasts, episodes, and later downloading entire files for offline playback
class APIService {
    
    //called a Singleton
    static let shared = APIService()
    
    //a class property so we can access it in any methods within ther class
    let baseiTunesSeacchURL = "https://itunes.apple.com/search"
    
    
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else { return}
        
        //MARK:- to fix search delay fetch these lines in background thread so we dont block the main thread (UI), what is gonna happen is we r gonna fetch XML feed & parse it in background thread 
        //
        DispatchQueue.global(qos: .background).async {
            print("before parser")
            let parser = FeedParser(URL: url)
            print("after parser")
            
            parser.parseAsync { (result) in
                print("Successfuly parse feed:", result.isSuccess)
                
                if let err = result.error {
                    print("Failed to parse XML feed:", err)
                    return
                }
                
                guard let feed = result.rssFeed else { return }
                
                let episodes = feed.topEpisode()
                completionHandler(episodes)
            }
            
        }
        
       
    }
    
    //closure param ([Podcast]) is an array of type Podcast
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        print("Searching for podcasts")
        
        
        //implement Alamofire to search iTunes API
        // let url = "https://itunes.apple.com/search?term=\(searchText)"
        
        
        //filter search we only interested in podcast - "media": "podcast"
        let parameters = ["term": searchText, "media": "podcast"]
        
        //URLEncoding.default will turn space between words in search to %20
        Alamofire.request(baseiTunesSeacchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("failed to connect yahoo", err)
                return
            }
            
            //MARK:_ code happen a synchronously means fecthing the podcast can take a couple seconds to finish cuz we need to reach out into the internet to get some data
            guard let data = dataResponse.data else {
                return
            }
            
            do {
                //MARK:_ the order of call
                print(3)
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                print("searchResult.resultCount", searchResult.resultCount)
                
                completionHandler(searchResult.results)
//                self.podcasts = searchResult.results
//                self.tableView.reloadData()
                
            } catch let decodeErr {
                print("Failed to decode", decodeErr)
            }
        }
        //MARK:_ the order of call
        print(2)
    }
    
    
    //4. implement a UISearchController
    // Decodable;  to transform json that we get form the api into Podcast model objects
    //to hold all our search result
    /*
     
     "results": [
     {"wrapperType":"track", "kind":"song", "artistId":272836694, "collectionId":273992420
     
     */
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
    
}
