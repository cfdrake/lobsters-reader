//
//  URLRequest+PaginatedRequest.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/25/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

extension URL {
    /// Returns the given URL with pagination query parameters added.
    func withPagination(page: UInt) -> URL {
        let hasBaseUrl = (baseURL != nil)
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: hasBaseUrl) else {
            fatalError("Could not unpack URL into components")
        }

        let pageString = String(describing: page)
        components.queryItems = [
            URLQueryItem(name: "page", value: pageString)
        ]

        guard let newUrl = components.url else {
            fatalError("Could not form new paginated URL")
        }

        return newUrl
    }
}
