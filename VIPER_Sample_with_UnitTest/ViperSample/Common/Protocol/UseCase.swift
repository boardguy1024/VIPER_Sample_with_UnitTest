//
//  UseCase.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import Foundation

protocol UseCaseProtocol where Failure: Error {
    associatedtype Parameter
    associatedtype Success
    associatedtype Failure
    
    func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?)
    func cancel()
}

final class UseCase<Parameter, Success, Failure: Error> {
    
    private let instance: UseCaseInstanceBase<Parameter, Success, Failure>
    
    init<T: UseCaseProtocol>(_ usecase: T) where
    T.Parameter == Parameter,
    T.Success == Success,
    T.Failure == Failure {
        self.instance = UseCaseInstance<T>(usecase)
    }
    
    func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?) {
        instance.execute(param, completion: completion)
    }
    
    func cancel() {
        instance.cancel()
    }
}


private extension UseCase {
    
    class UseCaseInstanceBase<Parameter, Success, Failure: Error> {
        func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?) {
            
            // ここは overrideして使うべきなのでoverrideしない場合、強制的にErrorを発生させる
            fatalError()
        }
        
        func cancel() {
            fatalError()
        }
    }
    
    class UseCaseInstance<T: UseCaseProtocol> : UseCaseInstanceBase<T.Parameter, T.Success, T.Failure> {

        private let usecase: T

        init(_ usecase: T) {
            self.usecase = usecase
        }
        
        override func execute(_ param: T.Parameter, completion: ((Result<T.Success, T.Failure>) -> Void)?) {
            usecase.execute(param, completion: completion)
        }
        
        override func cancel() {
            usecase.cancel()
        }
        
    }
}
