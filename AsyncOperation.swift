//
//  AsyncOperation.swift
//
//  Created by Vineeth Venugopal Ravindra on 6/12/17.
//

import Foundation

class AsyncOperation: Operation {
    
    internal enum Status: String {
        case ready, executing, finished
        fileprivate var KeyPath: String {
            return "is" + rawValue
        }
    }
    
    fileprivate var status = Status.ready {
        willSet {
            willChangeValue(forKey: newValue.KeyPath.capitalized)
            willChangeValue(forKey: status.KeyPath.capitalized)
        } didSet {
            didChangeValue(forKey: oldValue.KeyPath.capitalized)
            didChangeValue(forKey: status.KeyPath.capitalized)
        }
        
    }
}

extension AsyncOperation {
    override var isExecuting: Bool {
        return super.isExecuting && status == .executing
    }
    
    override var isReady: Bool {
        return status == .ready
    }
    
    override var isFinished: Bool {
        return status == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    override func start() {
        if isCancelled {
            status = .finished
            return
        }
        main()
        status = .executing
    }
    
    override func cancel() {
        super.cancel()
        status = .finished
    }
}
