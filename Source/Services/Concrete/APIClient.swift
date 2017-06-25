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

/// Lobste.rs API client.
final class APIClient: FeedPageFetching, TagFetching {
    let baseUrl: URL
    let session: URLSession

    init(baseUrl: URL = URL(string: "https://lobste.rs")!, session: URLSession = URLSession.shared) {
        self.baseUrl = baseUrl
        self.session = session
    }

    // MARK: Helpers

    fileprivate func decodeModels<T: Unboxable>(data: Data) -> [T]? {
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let jsonArray = json as! [UnboxableDictionary]
        return jsonArray.map { try! unbox(dictionary: $0) }
    }

    fileprivate func performModelFetch<T: Unboxable>(_ request: URLRequest, completion: @escaping (Result<[T], NSError>) -> Void) {
        let url = request.url!
        Logger.shared.log("Making request to \(url)...")

        let task = session.dataTask(with: request) { (data, response, error) in
            // TODO: Replace this.
            let err = NSError(domain: "", code: 0, userInfo: nil)

            if let error = error {
                // Networking error.
                Logger.shared.log("Error: \(error)...")
                completion(Result.failure(err))
            } else if let data = data {
                if let models: [T] = self.decodeModels(data: data) {
                    // Fetched models.
                    Logger.shared.log("Fetched \(models.count) model objects!")
                    completion(Result.success(models))
                } else {
                    // Parsing error.
                    Logger.shared.log("Parsing error...")
                    completion(Result.failure(err))
                }
            } else {
                // Unknown error.
                Logger.shared.log("Unknown error...")
                completion(Result.failure(err))
            }
        }

        task.resume()
    }

    // MARK: FeedPageFetching

    func fetch(feed: FeedType, page: UInt, completion: @escaping (Result<FeedPage, NSError>) -> Void) {
        guard let url = URL(string: feed.path, relativeTo: baseUrl)?.withPagination(page: page) else {
            fatalError("Could not form API URL")
        }

        performModelFetch(URLRequest(url: url), completion: completion)
    }

    // MARK: TagFetching

    func fetchTags(completion: @escaping (Result<[Tag], NSError>) -> Void) {
        guard let url = URL(string: "/tags.json", relativeTo: baseUrl) else {
            fatalError("Could not form API URL")
        }

        performModelFetch(URLRequest(url: url), completion: completion)
    }
}
