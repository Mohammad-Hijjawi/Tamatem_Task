//
//  CancellableWrapper.swift
//  TestProject
//
//  Created by Mohammad Hijjawi on 21/06/2023.
//

import Foundation
import Combine

// MARK: - Private Property
private var cancellableContext: UInt8 = 0

// MARK: - Private Wrapper Class
private class CancellableWrapper {
    let cancellables: Set<AnyCancellable>
    
    init(cancellables: Set<AnyCancellable>) {
        self.cancellables = cancellables
    }
}

// MARK: - NSObject Extension
public extension NSObject {
    @available(iOS 13.0, *)
    var cancellables: Set<AnyCancellable> {
        get {
            if let wrapper = objc_getAssociatedObject(self, &cancellableContext) as? CancellableWrapper {
                return wrapper.cancellables
            }
            let cancellables = Set<AnyCancellable>()
            self.cancellables = cancellables
            return cancellables
        }
        set {
            let wrapper = CancellableWrapper(cancellables: newValue)
            objc_setAssociatedObject(self, &cancellableContext, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
