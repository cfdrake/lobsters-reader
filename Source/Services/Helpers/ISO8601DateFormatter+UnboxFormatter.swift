//
//  ISO8601DateFormatter+UnboxFormatter.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/28/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Unbox

/// Adds support for unboxing Lobste.rs API dates.
extension ISO8601DateFormatter: UnboxFormatter {
    public func format(unboxedValue: String) -> Date? {
        // Total, utter hack. This removes the extra datetime precision of the lobste.rs API.
        return date(from: unboxedValue.replacingOccurrences(of: ".000-", with: "-"))
    }
}
