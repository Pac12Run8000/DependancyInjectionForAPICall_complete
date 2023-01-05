//
//  NetworkingService.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/2/23.
//

import Foundation

final class NetworkingService: NetworkingServiceForAPIResponse {
    public func fetchAPIResponse(url:URL, completion:@escaping(Result<AcronymObject,ResponseError>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
                completion(.failure(.badStatusCode))
                return
            }
            guard error == nil else {
                completion(.failure(.badResponse))
                return
            }
            
            print("MyData:\(data)")
            let parser = JsonParser<AcronymObject>()
            parser.parseData(data: data) { res in
                switch res {
                case .failure(_):
                    completion(.failure(ResponseError.noData))
                case.success(let obj):
                    completion(.success(obj))
                }
            }
        }
        task.resume()
    }
  
}


class MockNetworkingService: NetworkingServiceForAPIResponse {
    /*
     The url string value is: http://nactem.ac.uk/software/acromine/dictionary.py?sf=ax
     */
    func fetchAPIResponse(url: URL, completion: @escaping (Result<AcronymObject, ResponseError>) -> ()) {
        let acrObj = [DependancyInjectionForAPICall.AcronymElement(sf: "AX", lfs: [DependancyInjectionForAPICall.LF(lf: "arabinoxylan", freq: 35, since: 1991, vars: Optional([DependancyInjectionForAPICall.LF(lf: "arabinoxylan", freq: 14, since: 1994, vars: nil), DependancyInjectionForAPICall.LF(lf: "arabinoxylans", freq: 12, since: 1991, vars: nil), DependancyInjectionForAPICall.LF(lf: "Arabinoxylans", freq: 6, since: 2001, vars: nil), DependancyInjectionForAPICall.LF(lf: "Arabinoxylan", freq: 3, since: 2000, vars: nil)])), DependancyInjectionForAPICall.LF(lf: "amoxicillin", freq: 28, since: 1988, vars: Optional([DependancyInjectionForAPICall.LF(lf: "amoxicillin", freq: 23, since: 1991, vars: nil), DependancyInjectionForAPICall.LF(lf: "amoxycillin", freq: 4, since: 1988, vars: nil), DependancyInjectionForAPICall.LF(lf: "Amoxicillin", freq: 1, since: 2003, vars: nil)])), DependancyInjectionForAPICall.LF(lf: "axillary", freq: 12, since: 1991, vars: Optional([DependancyInjectionForAPICall.LF(lf: "axillary", freq: 10, since: 1991, vars: nil), DependancyInjectionForAPICall.LF(lf: "axillaris", freq: 2, since: 1993, vars: nil)])), DependancyInjectionForAPICall.LF(lf: "axial", freq: 12, since: 1998, vars: Optional([DependancyInjectionForAPICall.LF(lf: "axial", freq: 7, since: 1998, vars: nil), DependancyInjectionForAPICall.LF(lf: "ataxia", freq: 3, since: 2000, vars: nil), DependancyInjectionForAPICall.LF(lf: "Ataxia", freq: 1, since: 2003, vars: nil), DependancyInjectionForAPICall.LF(lf: "Axial", freq: 1, since: 2006, vars: nil)])), DependancyInjectionForAPICall.LF(lf: "astaxanthin", freq: 11, since: 1994, vars: Optional([DependancyInjectionForAPICall.LF(lf: "astaxanthin", freq: 8, since: 1994, vars: nil), DependancyInjectionForAPICall.LF(lf: "antheraxanthin", freq: 3, since: 2001, vars: nil)])), DependancyInjectionForAPICall.LF(lf: "Amidox", freq: 3, since: 1997, vars: Optional([DependancyInjectionForAPICall.LF(lf: "Amidox", freq: 2, since: 1997, vars: nil), DependancyInjectionForAPICall.LF(lf: "amidox", freq: 1, since: 1997, vars: nil)])), DependancyInjectionForAPICall.LF(lf: "Annexins", freq: 2, since: 1993, vars: Optional([DependancyInjectionForAPICall.LF(lf: "Annexins", freq: 1, since: 1993, vars: nil), DependancyInjectionForAPICall.LF(lf: "Annexin", freq: 1, since: 1996, vars: nil)]))])]
        
        completion(.success(acrObj))
    }
    
    
}
