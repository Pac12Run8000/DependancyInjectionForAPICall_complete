//
//  DependancyInjectionForAPICallTests.swift
//  DependancyInjectionForAPICallTests
//
//  Created by Michelle Grover on 1/3/23.
//

import XCTest
@testable import DependancyInjectionForAPICall

final class DependancyInjectionForAPICallTests: XCTestCase {
    /*
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
     */
    var mochNetworkingService:NetworkingServiceForAPIResponse!
    var viewModel:MainViewModel!
     
    
    override func setUp() {
        super.setUp()
        mochNetworkingService = MockNetworkingService()
        viewModel = MainViewModel(networkingService: mochNetworkingService)
    }
    
    override func tearDown() {
        super.tearDown()
        mochNetworkingService = nil
    }

    func testMockListGeneration() throws {
        let url = URL(string: TestConstants.axUrl)!
        mochNetworkingService.fetchAPIResponse(url: url) { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error)
            case .success(let acroObj):
                XCTAssertEqual(acroObj.count, 1)
                self.viewModel.fetchListFromAcronymObject(acrObj: acroObj) { res in
                    switch res {
                    case .success(let list):
                        XCTAssertEqual(list.count, 7)
                    case .failure(let err):
                        XCTAssertNil(err)
                    }
                }
            }
        }
        
        
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
