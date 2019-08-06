//
//  Observable.swift
//  WeatherApp
//
//  Created by Daheen Lee on 03/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation


class Observable<T> {
    typealias Observer = (T) -> Void
    var observer: Observer?
    
    func observe(_ observer: Observer?) {
        self.observer = observer
        guard let value = value else {
            return
        }
        observer?(value)
    }
    
    var value: T? {
        didSet {
            guard let value = value else {
                return
            }
            observer?(value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
}
