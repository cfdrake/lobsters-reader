//
//  AppInfoViewModel.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// Represents a section of application information.
struct AppInfoSectionViewModel {
    let title: String
    let links: [(String, URL)]
}

/// Application info view model.
typealias AppInfoViewModel = [AppInfoSectionViewModel]

/// Hardcoded list of links for app.
let defaultAppInfo: AppInfoViewModel = [
    AppInfoSectionViewModel(title: "Lobste.rs Links", links: [
        (title: "Hats", link: URL(string: "https://lobste.rs/hats")!),
        (title: "Moderation Log", link: URL(string: "https://lobste.rs/moderations")!),
        (title: "About Lobste.rs", link: URL(string: "https://lobste.rs/about")!)
    ]),
    AppInfoSectionViewModel(title: "Source Code", links: [
        (title: "App Source Code", link: URL(string: "https://github.com/cfdrake/lobsters-reader")!),
        (title: "Unbox", link: URL(string: "https://github.com/JohnSundell/Unbox")!),
        (title: "Result", link: URL(string: "https://github.com/antitypical/Result")!)
    ]),
    AppInfoSectionViewModel(title: "Icons", links: [
        (title: "Icons from Icons8", link: URL(string: "https://icons8.com")!)
    ])
]
