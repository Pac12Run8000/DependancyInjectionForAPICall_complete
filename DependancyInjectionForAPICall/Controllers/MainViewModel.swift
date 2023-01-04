//
//  MainViewModel.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/2/23.
//

import Foundation


/*
 I'm not creating an instance of my viewmodel. Instead, I am making a property and allowing it to be passed to the object during initialization.
 */


class MainViewModel {
    
    var networkingService:NetworkingServiceForAPIResponse
    
    init(networkingService: NetworkingServiceForAPIResponse) {
        self.networkingService = networkingService
    }
    
    var list:ObserveableObject<[String]> = ObserveableObject([])
    
    
    func fetchListForTableView(searchFieldInput:String?, completion:@escaping(Result<[String], Error>) -> ()) {
        
        guard let searchFieldInput = searchFieldInput?.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression) else {
            completion(.failure(SearchInputError.invalidInput))
            return
        }
        
        guard searchFieldInput != "" else {
            print("Enter somthing in the text field")
            completion(.failure(SearchInputError.emptyInput))
            return
        }
        
                
        guard !(searchFieldInput.trimmingCharacters(in: .whitespaces).isEmpty) else {
            print("There are white spaces but no characters.")
            completion(.failure(SearchInputError.onlyWhitespace))
            return
        }
        
        guard let url = fetchCompleteURL(key: .sf, value: searchFieldInput) else {
            print("No input entered.")
            completion(.failure(SearchInputError.noTextFieldFound))
            return
        }
        print("url:\(url)")
        networkingService.fetchAPIResponse(url: url) { result in
            switch result {
            case .failure(let error):
                print("There was an error:\(error.description)")
                completion(.failure(error))
            case .success(let data):
                print("data: \(data)")
                self.parseAPIResponse(data: data) { res in
                    switch res {
                    case .failure(let err):
                        print("err: \(err.localizedDescription)")
                        completion(.failure(err))
                    case .success(let list):
                        self.list.value = list
                        completion(.success(list))
                    }
                }
            }

        }
    }
    
    func parseAPIResponse(data:Data, completion:@escaping(Result<[String], ParseError>) -> ()) {
        var outputList = [String]()
        let parser = JsonParser<AcronymObject>()
        parser.parseData(data: data) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let output):
                print("output string:\(output)")
                if output.count > 0 {
                    for item in output[0].lfs {
                        outputList.append(item.lf)
                    }
                }
                completion(.success(outputList))
            }
        }
    }
    
    func fetchCompleteURL(key:URLQueryName, value:String) -> URL? {
        guard let url = URLComponentConstants.createURLWithComponents(queryParameters: [key.rawValue:value])?.url else {
            return nil
        }
        return url
    }
    
    
    
}
