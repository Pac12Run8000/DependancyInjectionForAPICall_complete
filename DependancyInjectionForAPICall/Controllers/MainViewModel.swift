//
//  MainViewModel.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/2/23.
//

import Foundation

class MainViewModel {
    
   
    
    var networkingService:NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    var list:ObserveableObject<[String]> = ObserveableObject([])
    
    func fetchListForTableView(searchFieldInput:String?) {
        
        guard let searchFieldInput = searchFieldInput?.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression) else {
            return
        }
        
        guard searchFieldInput != "" else {
            print("Enter somthing in the text field")
            return
        }
        guard let input = searchFieldInput as? String else {
            print("No search field found")
            return
        }
        
        guard !(searchFieldInput.trimmingCharacters(in: .whitespaces).isEmpty) else {
            print("There are white spaces but no characters.")
            return
        }
        
        guard let url = fetchCompleteURL(key: .sf, value: input) else {
            print("No input entered.")
            return
        }
        
        networkingService.fetchAPIResponse(url: url) { result in
            switch result {
            case .failure(let error):
                print("There was an error:\(error.description)")
            case .success(let data):
                self.parseAPIResponse(data: data) { res in
                    switch res {
                    case .failure(let err):
                        print("err: \(err.localizedDescription)")
                    case .success(let list):
                        self.list.value = list
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
                for item in output[0].lfs {
                    outputList.append(item.lf)
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
