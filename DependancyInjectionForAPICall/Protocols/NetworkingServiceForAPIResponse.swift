//
//  NetworkingServiceForAPIResponse.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/3/23.
//

import Foundation


protocol NetworkingServiceForAPIResponse {
    func fetchAPIResponse(url:URL, completion:@escaping(Result<Data,ResponseError>) -> ())
}
