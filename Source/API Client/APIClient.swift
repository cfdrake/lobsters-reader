//
//  APIClient.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Unbox
import Result

/// Lobste.rs JSON API client.
final class APIClient {

    // MARK: Static Properties

    static let defaultClient = APIClient()

    // MARK: Properties

    fileprivate let baseURL = URL(string: "https://lobste.rs")!
    fileprivate let session = URLSession.shared

    // MARK: Helpers

    fileprivate func urlForType(type: StoryType, page: Int) -> URL? {
        // Build basic path.
        let path = "/\(type.rawValue).json"

        guard let url = URL(string: path, relativeTo: baseURL) else {
            fatalError("APIClient could not construct base API URL")
        }

        // Attach query parameters.
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("APIClient could not deconstruct API URL")
        }

        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]

        return components.url
    }

    // MARK: Public Interface

    func fetchStories(ofType type: StoryType, page: Int = 1, completion: @escaping (Result<[Story], APIError>) -> Void) {
        guard let url = urlForType(type: type, page: page) else {
            fatalError("APIClient could not construct an API URL")
        }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for errors.
            if let _ = error {
                return completion(.failure(.networkingError))
            }

            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                // Successfully grabbed stories JSON.
                let jsonArray = json as! [UnboxableDictionary]
                let stories: [Story] = jsonArray.map { try! unbox(dictionary: $0) }
                completion(.success(stories))
            } else {
                // Invalid response.
                completion(.failure(.invalidResponse))
            }
        }

        task.resume()
    }

}
