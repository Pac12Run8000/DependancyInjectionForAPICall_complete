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
            case .success(let acronymObj):
                print("acronymObj: \(acronymObj)")
                self.fetchListFromAcronymObject(acrObj: acronymObj) { res in
                    switch res {
                    case .success(let output):
                        self.list.value = output
                    case .failure(_):
                        print("There was an error.")
                    }
                }
                
            }

        }
    }
    
    public func fetchListFromAcronymObject(acrObj:AcronymObject, completion:@escaping(Result<[String], Error>) -> ()) {
        var list = [String]()
        if acrObj.count > 0 {
            for item in acrObj[0].lfs {
                list.append(item.lf)
            }
        }
        completion(.success(list))
    }
    
    
    private func parseAPIResponse(data:Data, completion:@escaping(Result<AcronymObject, ParseError>) -> ()) {
        let parser = JsonParser<AcronymObject>()
        parser.parseData(data: data) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let output):
                completion(.success(output))
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
