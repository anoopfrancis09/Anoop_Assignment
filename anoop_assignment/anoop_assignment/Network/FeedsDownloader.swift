//
//  FeedsDownloader.swift
//  Instagram
//
//  Created by Apple on 26/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
struct FeedsDownloader {
    
    /// The current count of feeds downloaded. This can be used in case api is asking for count in case of paginating
    var currentCount = 0
    
     /// The total count of feeds. This is required to know if we reach the last page
    var totalCount = 0
    
    /// The current page which we are downloading.  This can be used in case api is asking for pages in case of paginating
    var pageNumber = 0
    
    /// The total pages of feeds. This is required to know if we reach the last page
    var totalPage = 0
    
    /// Call this function to get the feeds
    ///
    /// We need to use either pages count or feeds count (depening on the api. We can update the values from the response)
    /// - Parameters:
    ///   - pageNumber: pageNumber is the current page
    ///   - completion: will return feeds or error message
    func getFeeds(completion: @escaping ([Feed]?, String?) -> Void) {

        let urlString = "https://pastebin.com/raw/wgkJgazE"
        let networkHandler = NetworkHandler()
        networkHandler.send(urlString: urlString, body: nil, method: HttpMethod.GET, successHandler: { (feeds: [Feed])  in
            completion(feeds, nil)
        }, errorHandler: { (errorMessage) in
            completion(nil, errorMessage)
        })
    }
}


