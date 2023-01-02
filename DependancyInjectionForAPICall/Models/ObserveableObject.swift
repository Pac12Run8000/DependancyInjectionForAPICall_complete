//
//  ObserveableObject.swift
//  DependancyInjectionForAPICall
//
//  Created by Michelle Grover on 1/2/23.
//

import Foundation

final class ObserveableObject<T> {
    var value:T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener:((T) -> ())?
    
    init(_ value:T) {
        self.value = value
    }
    
    func bind(_ listener:@escaping(T) -> ()) {
        listener(value)
        self.listener = listener
    }
}

