//
//  URLComponentConstants.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/2/23.
//

import Foundation

struct URLComponentConstants {
    
    static let scheme:String = "http"
    static let host:String = "nactem.ac.uk"
    static let path:String = "/software/acromine/dictionary.py"
        
    static func createURLWithComponents(queryParameters:[String:String]? = nil) -> URLComponents? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
            return components
        }
}

enum URLQueryName:String {
    case sf
    case lf
}

struct TestConstants {
    static let axUrl = "http://nactem.ac.uk/software/acromine/dictionary.py?sf=ax"
}

