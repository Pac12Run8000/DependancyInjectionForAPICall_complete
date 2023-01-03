//
//  DependancyProvider.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/2/23.
//

import Foundation
import UIKit

struct DependancyProvider {
    static var service:NetworkingServiceForAPIResponse {
        return NetworkingService()
    }
    
    static var viewModel:MainViewModel {
        return MainViewModel(networkingService: self.service)
    }
    
    static var viewController:MainViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainViewController
        vc.viewModel = viewModel
        return vc
    }
}
