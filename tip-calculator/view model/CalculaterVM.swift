//
//  CalculaterVM.swift
//  tip-calculator
//
//  Created by 山本響 on 2023/03/25.
//

import Foundation
import Combine

class CalculaterVM {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublichser: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        let result = Result(amountPerPerson: 500, totalBill: 1000, totalTip: 50.0)
        
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
}
