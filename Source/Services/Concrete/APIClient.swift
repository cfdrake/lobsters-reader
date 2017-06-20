//
//  APIClient.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Result
import Unbox

/// API client for Lobste.rs JSON API.
final class APIClient: StoryFetching {
    fileprivate static let defaultBaseUrl = URL(string: "https://lobste.rs")!
    static let `default` = APIClient(baseURL: defaultBaseUrl)
    fileprivate let baseURL: URL
    fileprivate let session: URLSession

    init(baseURL: URL) {
        self.baseURL = baseURL
        self.session = URLSession.shared
    }

    // MARK: Helpers

    fileprivate func requestForFeed(_ feed: Feed, page: UInt) -> URLRequest {
        guard let url = URL(string: feed.path, relativeTo: baseURL) else {
            fatalError("Could not construct API URL")
        }

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("Could not deconstruct components from API URL")
        }

        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let finalUrl = components.url else {
            fatalError("Could not unpack final API URL")
        }

        return URLRequest(url: finalUrl)
    }

    // MARK: StoryFetching

    func fetchStories(fromFeed feed: Feed, page: UInt, completion: @escaping (Result<[Story], StoryFetchingError>) -> Void) {
        let request = requestForFeed(feed, page: page)

        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                let reason = "You must be connected to the network to fetch new stories. Please connect and try again."
                completion(Result.failure(StoryFetchingError(reason: reason)))
            } else if let data = data {
                // We'll assume that the data provided from the official API is going to be in the expected format.
                // Thus, the force-unwraps (for now at least).
                let json = try! JSONSerialization.jsonObject(with: data, options: [])
                let jsonArray = json as! [UnboxableDictionary]
                let stories: [Story] = jsonArray.map { try! unbox(dictionary: $0) }
                completion(Result.success(stories))
            } else {
                let reason = "There was an issue with the data from the server. Please try again."
                completion(Result.failure(StoryFetchingError(reason: reason)))
            }
        }

        task.resume()
    }
}
