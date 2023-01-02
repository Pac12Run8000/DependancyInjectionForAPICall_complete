//
//  MainViewModel.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/2/23.
//

import Foundation

class MainViewModel {
    
    var list:ObserveableObject<[String]> = ObserveableObject([])
    
    func fetchListForTableView(searchFieldInput:String?) {
        guard let input = searchFieldInput else {
            print("No search field found")
            return
        }
        guard let url = fetchCompleteURL(key: .sf, value: input) else {
            print("No input entered.")
            return
        }
        print("url:\(url)")
        
        
    }
    
    func parseAPIResponse(data:Data, completion:@escaping(Result<Bool, ParseError>) -> ()) {
        var outputList = [String]()
        let parser = JsonParser<AcronymObject>()
        parser.parseData(data: data) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let output):
                for item in output[0].lfs {
                    outputList.append(item.lf)
                }
                self.list.value = outputList
                completion(.success(true))
            }
        }
    }
    
    func fetchCompleteURL(key:URLQueryName, value:String) -> URL? {
        guard let url = URLComponentConstants.createURLWithComponents(queryParameters: [key.rawValue:value])?.url else {
            return nil
        }
        return url
    }
    
    func fetchDataResponse(url:URL?, session:URLSession = URLSession.shared, completion:@escaping(Result<Data, ResponseError>) -> ()) {
        guard let url = url else {
            completion(.failure(.noUrl))
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
                completion(.failure(.badStatusCode))
                return
            }
            guard error == nil else {
                completion(.failure(.badStatusCode))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
}
