//
//  Dynamic.swift
//  ViewControls
//
//  Created by Lammert Westerhoff on 10/10/15.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = T -> Void
    var listener: Listener?

    func bind(listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
