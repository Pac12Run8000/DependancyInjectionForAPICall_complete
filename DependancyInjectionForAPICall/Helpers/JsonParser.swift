//
//  JsonParser.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/2/23.
//

import Foundation

struct JsonParser<T:Decodable> {
    
    public func parseData(data:Data, completion:@escaping(Result<T, ParseError>) -> ()) {
        var output:T?
        do {
            output = try JSONDecoder().decode(T.self, from: data)
            completion(.success(output!))
        } catch {
            completion(.failure(.modelNotMatchingData))
        }
    }
    

    
}
