//
//  CalculaterVC.swift
//  tip-calculator
//
//  Created by 山本響 on 2023/03/21.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculaterVC: UIViewController {
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()
    
    private let vm = CalculaterVM()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        observe()
    }
    
    private func bind() {
        
        let input = CalculaterVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublichser: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher,
            logoViewTapPublisher: logoViewTapPublisher)
        
        let output = vm.transform(input: input)

        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }.store(in: &cancellables)
        
        output.resultCalculatorPublisher.sink { _ in
            print("hey, reset the form please")
        }.store(in: &cancellables)
    }

    private func observe() {
        viewTapPublisher.sink { [unowned self] in
            view.endEditing(true)
        }.store(in: &cancellables)
        
        logoViewTapPublisher.sink { _ in
            print("logo view is tapped")
        }.store(in: &cancellables)
    }
    
    private func layout() {
        view.backgroundColor = ThemeColor.bg
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+16)
        }
        
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }

}

