/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Glean

public enum BasicSearchProvider: String {
    case google
    case duckduckgo
    case yahoo
    case bing
}

public struct SearchProviderModel {
    let name: String
    let regexp: String
    let queryParam: String
    let codeParam: String
    let codePrefixes: [String]
    let followOnParams: [String]
    let extraAdServersRegexps: [String]
    
    public static let searchProviderList = [
        SearchProviderModel(name: BasicSearchProvider.google.rawValue,
                            regexp: #"^https:\/\/www\.google\.(?:.+)\/search"#,
                            queryParam: "q", codeParam: "client",
                            codePrefixes: ["firefox"],
                            followOnParams: ["oq", "ved", "ei"],
                            extraAdServersRegexps: [ #"^https?:\/\/www\.google(?:adservices)?\.com\/(?:pagead\/)?aclk"#, #"^(http|https):\/\/clickserve.dartsearch.net\/link\/"#]),
        SearchProviderModel(name: BasicSearchProvider.duckduckgo.rawValue,
                            regexp: #"^https:\/\/duckduckgo\.com\/"#,
                            queryParam: "q",
                            codeParam: "t",
                            codePrefixes: ["f"],
                            followOnParams: [],
                            extraAdServersRegexps: [ #"^https:\/\/duckduckgo.com\/y\.js"#, #"^https:\/\/www\.amazon\.(?:[a-z.]{2,24}).*(?:tag=duckduckgo-)"#]),
        SearchProviderModel(name: BasicSearchProvider.yahoo.rawValue,
                            regexp: #"^https:\/\/(?:.*)search\.yahoo\.com\/search"#,
                            queryParam: "p",
                            codeParam: "",
                            codePrefixes: [],
                            followOnParams: [],
                            extraAdServersRegexps: [#"^(http|https):\/\/clickserve.dartsearch.net\/link\/"#, #"^https:\/\/www\.bing\.com\/acli?c?k"#, #"^https:\/\/www\.bing\.com\/fd\/ls\/GLinkPingPost\.aspx.*acli?c?k"#]),
        SearchProviderModel(name: BasicSearchProvider.bing.rawValue,
                            regexp: #"^https:\/\/www\.bing\.com\/search"#,
                            queryParam: "q",
                            codeParam: "pc",
                            codePrefixes: ["MOZ", "MZ"],
                            followOnParams: ["oq"],
                            extraAdServersRegexps: [#"^https:\/\/www\.bing\.com\/acli?c?k"#, #"^https:\/\/www\.bing\.com\/fd\/ls\/GLinkPingPost\.aspx.*acli?c?k"#])
    ]
}
