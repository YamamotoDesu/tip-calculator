# tip-calculator
MVVM, Combine, SnapKit, Snapshot/UI/Unit Tests 

https://www.udemy.com/course/ios-swift-mvvm-combine-snapkit-snapshot-ui-unit-tests

## Introduction
### Set up Project

```swift
private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()
```

<img width="377" alt="スクリーンショット 2023-03-21 10 45 57" src="https://user-images.githubusercontent.com/47273077/226500737-29298eec-001e-4588-9880-d4507ffada0c.png">

```swift
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
```
 

```swift
import UIKit
import SnapKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
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
```

LogoView
```swift
import UIKit

class LogoView: UIView {
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .red
    }
}
```


## Setup UI
### Add Theme Constant

⭐️ https://coolors.co/palettes/trending 

⭐️ https://developer.apple.com/fonts/system-fonts/  

UIColor+Extention.swift
```swift
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

```

ThemeColor.swift
```swift
import UIKit

struct ThemeColor {
    static let bg = UIColor(hexString: "F5F3F4")
    static let primary = UIColor(hexString: "1CC98E")
    static let secondary = UIColor.systemOrange
    static let text = UIColor(hexString: "000000")
    static let separator = UIColor(hexString: "CCCCCC")
    
}
```

ThemeFont.swift
```swift

import UIKit

struct ThemeFont {
    // Avenir Next
    static func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func dembold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-DemBold", size: size) ?? .systemFont(ofSize: size)
    }
}
```

### Add LogoView Detail

<img width="300" src="https://user-images.githubusercontent.com/47273077/226533725-1d9419e1-3338-4563-abfc-8141cd3de226.png">

LabelFactory.swift
```swift
import UIKit

struct LabelFactory {
    
    static func build(
        text: String?,
        font: UIFont,
        backgroundColor: UIColor = .clear,
        textColor: UIColor = ThemeColor.text,
        textAlignment: NSTextAlignment = .center) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = font
            label.backgroundColor = backgroundColor
            label.textColor = textColor
            label.textAlignment = textAlignment
            return label
        }
}
```

LogoView.swift
```swift
import UIKit

class LogoView: UIView {
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: .init(named: "icCalculatorBW"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(
            string: "Mr TIP",
            attributes: [.font: ThemeFont.dembold(ofSize: 16)]
        )
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(3, 3))
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel: UILabel = {
        LabelFactory.build(
            text: "Calculator",
            font: ThemeFont.dembold(ofSize: 20),
            textAlignment: .left)
    }()
    
    private lazy var vStackViews: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            topLabel,
            bottomLabel
        ])
        view.axis = .vertical
        view.spacing = -4
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            imageView,
            vStackViews
        ])
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
    }
}
```

### Add Result View
<img width="300" alt="スクリーンショット 2023-03-21 19 01 07" src="https://user-images.githubusercontent.com/47273077/226573367-25313051-90ae-4b59-9f0b-3f0e3d8d4ba9.png">

ResultView.swift
```swift
//
//  ResultView.swift
//  tip-calculator
//
//  Created by 山本響 on 2023/03/21.
//

import UIKit

class ResultView: UIView {
    
    private let headerLabel: UILabel = {
        LabelFactory.build(
            text: "Total p/person",
            font: ThemeFont.demibold(ofSize: 18))
    }()
    
    private let amountForPersonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [
                .font: ThemeFont.bold(ofSize: 40)
            ])
        text.addAttributes([
            .font: ThemeFont.bold(ofSize: 24)
        ], range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            amountForPersonLabel,
            horizontalLineView,
            buildSpacerView(height: 0),
            hStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            AmountView(),
            UIView(),
            AmountView()
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .white
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        horizontalLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        
        addShadow(
            offset: CGSize(width: 0, height: 3),
            color: .blue,
            radius: 12.0,
            opacity: 0.1)
    }
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
}

class AmountView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .red
    }
}

```

UIView+Extention.swift
```swift
import UIKit

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        
        layer.backgroundColor = backgroundCGColor
    }
}
```

### Add Amount View
<img width="300" alt="スクリーンショット 2023-03-21 21 07 20" src="https://user-images.githubusercontent.com/47273077/226601342-a76c6b00-16f2-4f45-9f94-3a15e4c6d7e3.png">

ResultView.swift
```swift
import UIKit

class ResultView: UIView {
    
    private let headerLabel: UILabel = {
        LabelFactory.build(
            text: "Total p/person",
            font: ThemeFont.demibold(ofSize: 18))
    }()
    
    private let amountForPersonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [
                .font: ThemeFont.bold(ofSize: 40)
            ])
        text.addAttributes([
            .font: ThemeFont.bold(ofSize: 24)
        ], range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            amountForPersonLabel,
            horizontalLineView,
            buildSpacerView(height: 0),
            hStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            AmountView(
                title: "Total bill",
                textAlignment: .left),
            UIView(),
            AmountView(
                title: "Total tip",
                textAlignment: .right)
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .white
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        horizontalLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        
        addShadow(
            offset: CGSize(width: 0, height: 3),
            color: .blue,
            radius: 12.0,
            opacity: 0.1)
    }
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
}
```

AmountView.swift
```swift
import UIKit

class AmountView: UIView {
    
    private let title: String
    private let textAlignment: NSTextAlignment
    
    private lazy var titleLabel: UILabel = {
        LabelFactory.build(
            text: title,
            font: ThemeFont.regular(ofSize: 18),
            textColor: ThemeColor.text,
            textAlignment: textAlignment
        )
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = textAlignment
        label.textColor = ThemeColor.primary
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [
                .font: ThemeFont.bold(ofSize: 24)
            ])
        text.addAttributes([
            .font: ThemeFont.bold(ofSize: 16)
        ], range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            amountLabel
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    init(title: String, textAlignment: NSTextAlignment) {
        self.title = title
        self.textAlignment = textAlignment
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

```

### Add Bill Input View Details
<img width="300" alt="スクリーンショット 2023-03-22 15 05 28" src="https://user-images.githubusercontent.com/47273077/226816431-bee01cb4-7d38-41cd-896a-1f9be0d509a5.png">

UIView+Extention.swift
```swift
extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        
        layer.backgroundColor = backgroundCGColor
    }
    
    func addCornerRadius(radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}
```

BillInputView.swift
```swift
import UIKit

class BillInputView: UIView {
    
    private let headerView: HeaderView = {
       return HeaderView()
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 0.0)
        return view
    }()
    
    private let currencyDenominationLabel: UILabel = {
        let label = LabelFactory.build(
            text: "$",
            font: ThemeFont.bold(ofSize: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.demibold(ofSize: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        // Add toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(self.doneButtonTapped))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: nil,
                            action: nil),
            doneButton
        ]
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        return textField
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [headerView, textFieldContainerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textFieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textFieldContainerView.addSubview(currencyDenominationLabel)
        textFieldContainerView.addSubview(textField)
        
        currencyDenominationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc private func doneButtonTapped() {
        textField.endEditing(true)
    }
}

class HeaderView: UIView {
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .red
    }
}
```

### Add Header View Details

<img width="300" alt="スクリーンショット 2023-03-22 15 30 46" src="https://user-images.githubusercontent.com/47273077/226820472-2ec77c49-1ad6-4875-8f88-ffeb349c16b9.png">

```swift
import UIKit

class BillInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.cofigure(
            topText: "Enter",
            bottomText: "your bill")
        return view
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 0.0)
        return view
    }()
    
    private let currencyDenominationLabel: UILabel = {
        let label = LabelFactory.build(
            text: "$",
            font: ThemeFont.bold(ofSize: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.demibold(ofSize: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        // Add toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(self.doneButtonTapped))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: nil,
                            action: nil),
            doneButton
        ]
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        return textField
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [headerView, textFieldContainerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textFieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textFieldContainerView.addSubview(currencyDenominationLabel)
        textFieldContainerView.addSubview(textField)
        
        currencyDenominationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc private func doneButtonTapped() {
        textField.endEditing(true)
    }
}

class HeaderView: UIView {
    
    private let topLabel: UILabel = {
        LabelFactory.build(
            text: nil,
            font: ThemeFont.bold(ofSize: 18))
    }()
    
    private let bottomLabel: UILabel = {
        LabelFactory.build(
            text: nil,
            font: ThemeFont.regular(ofSize: 16))
    }()
    
    private let topSpacerView = UIView()
    private let bottomSpacerView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topSpacerView,
            topLabel,
            bottomLabel,
            bottomSpacerView
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = -6
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topSpacerView.snp.makeConstraints { make in
            make.height.equalTo(bottomSpacerView.snp.height)
        }
    }
    
    func cofigure(topText: String, bottomText: String) {
        topLabel.text = topText
        bottomLabel.text = bottomText
    }
}
```


### 10. Add Tip Input View Details
<img width="300" alt="スクリーンショット 2023-03-24 9 59 37" src="https://user-images.githubusercontent.com/47273077/227397538-bde48c94-f812-4120-b67e-f72388fe47c3.png">

TipInputView.swift
```swift
import UIKit

class TipInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.cofigure(topText: "Choose", bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        return button
    }()

    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentTipButton,
            fifteenPercentTipButton,
            twentyPercentTipButton
        ])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [headerView, buttonVStackView].forEach(addSubview(_:))
        buttonVStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonHStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(buttonHStackView.snp.centerY)
        }
    }
    
    private func buildTipButton(tip: Tip) -> UIButton{
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8.0)
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(ofSize: 20),
                .foregroundColor: UIColor.white
            ])
        text.addAttributes([
            .font: ThemeFont.demibold(ofSize: 14)
        ], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
}
```

Tip.swift
```swift
import Foundation

enum Tip {
    case none
    case tenPercent
    case fifteenPercent
    case twentyPercent
    case custom(value: Int)
    
    var stringValue: String {
        switch self {
        case .none:
            return ""
        case .tenPercent:
            return "10%"
        case .fifteenPercent:
            return "15%"
        case .twentyPercent:
            return "20%"
        case .custom(let value):
            return String(value)
        }
    }
}
```

## 11. Add Split Input View Details

<img width="300" alt="スクリーンショット 2023-03-25 11 49 35" src="https://user-images.githubusercontent.com/47273077/227683900-63aa8ee6-6cb5-4636-8035-24749552735f.png">

UIView+Extention.swift
```swift
    func addRoundedCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = (corners)
    }
 ```
 
 SplitInputView.swift
 ```swift
 class SplitInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.cofigure(topText: "Split", bottomText: "total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = buildButton(text: "-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildButton(text: "-", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(
            text: "1",
            font: ThemeFont.bold(ofSize: 20),
            backgroundColor: .white)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            decrementButton,
            quantityLabel,
            incrementButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        [headerView, stackView].forEach(addSubview(_:))
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementButton, decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.trailing.equalTo(stackView.snp.leading).offset(-24)
            make.width.equalTo(60)
        }
    }
    
    private func buildButton(text: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.addRoundedCorners(corners: corners, radius: 0.0)
        return button
    }
}
```

# Setup View Model
## Add View Model

Result.swift
```swift
struct Result {
    let amountPerPerson: Double
    let totalBill: Double
    let totalTip: Double
}
```

CalculaterVM.swift
```swift
class CalculaterVM {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublichser: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
    }
    
    func transform(input: Input) -> Output {
        
        let result = Result(amountPerPerson: 500, totalBill: 1000, totalTip: 50.0)
        
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
}
```

ViewController.swift
```swift
    private let vm = CalculaterVM()
    private var cancelleables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    private func bind() {
        
        let input = CalculaterVM.Input(
            billPublisher: Just(10).eraseToAnyPublisher(),
            tipPublichser: Just(.tenPercent).eraseToAnyPublisher(),
            splitPublisher: Just(5).eraseToAnyPublisher())
        
        let output = vm.transform(input: input)
        
        output.updateViewPublisher.sink { result in
            print(">>> \(result)")
        }.store(in: &cancelleables)

    }
  
  
```
  
```
  >>> Result(amountPerPerson: 500.0, totalBill: 1000.0, totalTip: 50.0)
```

## Observe Bill Input View
String+Extention.swift
```swift
extension String {
    var doubleValue: Double? {
        Double(self)
    }
}
```

BillInputView.swift
```swift
    private let billSubject: PassthroughSubject<Double, Never> = .init()
    var valuePublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe() {
        textField.textPublisher.sink { [unowned self] text in
            billSubject.send(text?.doubleValue ?? 0)
            print("Text: \(text)")
        }.store(in: &cancellables)
    }
```

ViewController.swift
```swift
    private func bind() {
        
        
        let input = CalculaterVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublichser: Just(.tenPercent).eraseToAnyPublisher(),
            splitPublisher: Just(5).eraseToAnyPublisher())
        
        let output = vm.transform(input: input)


    }
 ```
 
 CalculaterVM.swift
 ```swift
   private var cancellables = Set<AnyCancellable>()
 ```

## [Observe Tip Input View](https://github.com/YamamotoDesu/tip-calculator/commit/4f6c109dcdbcba86730f7dfef2b762632b72eb8c)
CalculaterVM.swift
```swift
    func transform(input: Input) -> Output {
        
        input.tipPublichser.sink { tip in
            print("the tip \(tip)")
        }.store(in: &cancellables)
        
        let result = Result(amountPerPerson: 500, totalBill: 1000, totalTip: 50.0)
        
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
```

TipInputView.swift
```swift
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.tenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.fifteenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher.flatMap {
            Just(Tip.twentyPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private let tipSubject = CurrentValueSubject<Tip, Never>(.none)
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
 ```
 
 ViewController.swift
 ```swift
     private func bind() {
        
        
        let input = CalculaterVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublichser: tipInputView.valuePublisher,
            splitPublisher: Just(5).eraseToAnyPublisher())
        
        let output = vm.transform(input: input)


    }
  ```
  
## [Handle Custom Tip Button](https://github.com/YamamotoDesu/tip-calculator/commit/1dddb0810c68c3a0841cb29eec2f2fa8c0e8682f)
  
<img width="300" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/227815741-9c91c31e-ff6e-411d-a767-c9af4538f0d3.gif">

UIResponder+Entention.swift
```swift
import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
```

TipInputView.swift
```swift
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }.store(in: &cancellables)
        return button
    }()
    
    private func handleCustomTipButton() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(
                title: "Enter custom tip",
                message: nil,
                preferredStyle: .alert)
            controller.addTextField { textField in
                textField.placeholder = "Make it generous"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
            }
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default) { [weak self] _ in
                    guard let text = controller.textFields?.first?.text,
                          let value = Int(text) else { return }
                    
                    self?.tipSubject.send(.custom(value: value))
                }
            [cancelAction, okAction].forEach(controller.addAction(_:))
            return controller
        }()
        parentViewController?.present(alertController, animated: true)
    }
    
```

## [Handle Custom Tip Button Selection State](https://github.com/YamamotoDesu/tip-calculator/commit/42ceb18a0d1ab7f1900d704bd9aa50812db05bd1)

<img width="300" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/227818664-d5b4ed36-0429-43b2-a090-289a58b24d92.gif">

TipInputView.swift
```swift

    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }

    private func observe() {
        tipSubject.sink { [unowned self] tip in
            resetView()
            switch tip {
            case .none: break
            case .tenPercent:
                tenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                fifteenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyPercentTipButton.backgroundColor = ThemeColor.secondary
            case .custom(let value):
                customTipButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(
                    string: "$\(value)",
                    attributes: [.font: ThemeFont.bold(ofSize: 20)])
                text.addAttributes([
                    .font: ThemeFont.bold(ofSize: 14)
                ], range: NSMakeRange(0, 1))
                customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellables)
    }
    
    private func resetView() {
        [tenPercentTipButton,
         fifteenPercentTipButton,
         twentyPercentTipButton,
         customTipButton].forEach {
            $0.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font: ThemeFont.bold(ofSize: 20)])
        customTipButton.setAttributedTitle(text, for: .normal)
    }
```

## [Observe Split Input View](https://github.com/YamamotoDesu/tip-calculator/commit/4fff4bbd86c2760afbe50c99b4bca1136309b3cc)

<img width="500" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/228719895-0893b293-79f0-423b-a91f-d4cd11e11cf7.gif">

Int+Extention.swift
```swift
import Foundation

extension Int {
    var stringValue: String {
        return String(self)
    }
}
```

CalculaterVM.swift
```swift
class CalculaterVM {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublichser: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }

   func transform(input: Input) -> Output {

        input.splitPublisher.sink { split in
            print("the split \(split)")
        }.store(in: &cancellables)
```

SplitInputView.swift
```swift
    private lazy var decrementButton: UIButton = {
        let button = buildButton(
            text: "-",
            corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        button.tapPublisher.flatMap { [unowned self] in
            Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellable)
        return button
    }()

    private lazy var incrementButton: UIButton = {
        let button = buildButton(
            text: "+",
            corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        button.tapPublisher.flatMap { [unowned self] in
            Just(splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellable)
        return button
    }()
    
        private let splitSubject: CurrentValueSubject<Int, Never> = .init(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
        private func observe() {
        splitSubject.sink { [unowned self] quantity in
            quantityLabel.text = quantity.stringValue
        }.store(in: &cancellable)
    }
```


TipInputView.swift
```swift
private let tipSubject:CurrentValueSubject<Tip, Never> = .init(.none)
```

## [Compute Result In View Model](https://github.com/YamamotoDesu/tip-calculator/commit/e0cbdcb28f9c0432bd7257e070d3551718394a8d)
<img width="300" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/228734139-420f0b74-2332-4163-bbe2-6a38d2a651dc.gif">

CalculaterVM.swift
```swift
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
        
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublichser,
            input.splitPublisher).flatMap { [unowned self] bill, tip, split in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)
                
                let result = Result(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalBill,
                    totalTip: totalTip)
                return Just(result)
            }.eraseToAnyPublisher()
        return Output(updateViewPublisher: updateViewPublisher)
    }
    
    private func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(let value):
            return Double(value)
        }
    }
 ```

## [Display Result In Result View](https://github.com/YamamotoDesu/tip-calculator/commit/f2aa258374b199ba5f44ffe2af02751ac440cec8)

<img width="300" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/229047368-bdc5029a-1fa9-473d-a767-26ec89282314.gif">

ResultView.swift
```swift
    private let totalBillView: AmountView = {
        let view = AmountView(
            title: "Total bill",
            textAlignment: .left)
        return view
    }()
    
    private let totalTipView: AmountView = {
        let view = AmountView(
            title: "Total tip",
            textAlignment: .right)
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            totalBillView,
            UIView(),
            totalTipView
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    func configure(result: Result) {
        let text = NSMutableAttributedString(
            string: String(result.amountPerPerson),
            attributes: [.font: ThemeFont.bold(ofSize: 48)])
        text.addAttributes([
            .font: ThemeFont.bold(ofSize: 24)
        ], range: NSMakeRange(0, 1))
        amountForPersonLabel.attributedText = text
        totalBillView.confiure(text: String(result.totalBill))
        totalTipView.confiure(text: String(result.totalTip))
    }
```

AmountView.swift
```swift
    func confiure(text: String) {
        let text = NSMutableAttributedString(
            string: text,
            attributes: [.font: ThemeFont.bold(ofSize: 24)])
        text.addAttributes(
            [.font: ThemeFont.bold(ofSize: 16)],
            range: NSMakeRange(0, 1))
        amountLabel.attributedText = text
    }
```

ViewController.swift
```swift
    private func bind() {
        
        let input = CalculaterVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublichser: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher)
        
        let output = vm.transform(input: input)

        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }.store(in: &cancellables)
    }
```

## [Format Currency Values](https://github.com/YamamotoDesu/tip-calculator/commit/ab8cf1df4df95ca0ee09823367e3d486d231897e)

<img width="300" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/229077061-10541566-a18f-4854-bb40-8d6aefb72523.gif">

Double+Extention.swift
```
extension Double {
    var currencyFormatted: String {
        var isWholeNumber: Bool {
            isZero ? true: !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        return formatter.string(for: self) ?? ""
    }

}
```

ResultView.swift
```swift
    func configure(result: Result) {
        let text = NSMutableAttributedString(
            string: result.amountPerPerson.currencyFormatted,
            attributes: [.font: ThemeFont.bold(ofSize: 48)])
        text.addAttributes([
            .font: ThemeFont.bold(ofSize: 24)
        ], range: NSMakeRange(0, 1))
        amountForPersonLabel.attributedText = text
        totalBillView.confiure(amount: result.totalBill)
        totalTipView.confiure(amount: result.totalTip)
    }
    
```

AmountView.swift
```swift
    func confiure(amount: Double) {
        let text = NSMutableAttributedString(
            string: amount.currencyFormatted,
            attributes: [.font: ThemeFont.bold(ofSize: 24)])
        text.addAttributes(
            [.font: ThemeFont.bold(ofSize: 16)],
            range: NSMakeRange(0, 1))
        amountLabel.attributedText = text
    }
 ```

## [Add Tap Gestures](https://github.com/YamamotoDesu/tip-calculator/commit/c21665579d7805df8b9c7763ef55452b5a1df114)

<img width="300" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/229087524-d9ffb58b-394e-499c-90fd-328e5ff2c016.gif">

CalculaterVC.swift
```swift
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

    private func observe() {
        viewTapPublisher.sink { [unowned self] in
            view.endEditing(true)
        }.store(in: &cancellables)
        
        logoViewTapPublisher.sink { _ in
            print("logo view is tapped")
        }.store(in: &cancellables)
    }
```

## [Send Gesture Tap Publisher To VM](https://github.com/YamamotoDesu/tip-calculator/commit/c43e033ba91c4126d23109b8cecb547f1560f16d)

<img width="300" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/229330304-b162beb1-9d56-4d46-8d42-ad39a3d604c3.gif">

CalculaterVM.swift
```swift
class CalculaterVM {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublichser: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
        let resultCalculatorPublisher: AnyPublisher<Void, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublichser,
            input.splitPublisher).flatMap { [unowned self] bill, tip, split in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)
                
                let result = Result(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalBill,
                    totalTip: totalTip)
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resultCalculatorPublisher = input.logoViewTapPublisher
        
        return Output(updateViewPublisher: updateViewPublisher,
                      resultCalculatorPublisher: resultCalculatorPublisher)
    }
```

## Add Sound Effect On LogoView Tap
AudioPlayerService.swift
```swift
import Foundation
import AVFoundation

protocol AudioPlayerServie {
    func playSound()
}

final class DefaultAudioPlayer: AudioPlayerServie {
    
    private var player: AVAudioPlayer?
    
    func playSound() {
        let path = Bundle.main.path(forResource: "click", ofType: "m4a")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
```

CalculaterVM.swift
```swift
class CalculaterVM {

    private let audioPlayerServie: AudioPlayerServie
    init(audioPlayerServie: AudioPlayerServie = DefaultAudioPlayer()) {
        self.audioPlayerServie = audioPlayerServie
    }
    
    func transform(input: Input) -> Output {
        
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublichser,
            input.splitPublisher).flatMap { [unowned self] bill, tip, split in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)
                
                let result = Result(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalBill,
                    totalTip: totalTip)
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resultCalculatorPublisher = input
            .logoViewTapPublisher
            .handleEvents(receiveOutput: { [unowned self] in
            audioPlayerServie.playSound()
        }).flatMap {
            return Just(($0))
        }.eraseToAnyPublisher()
        
        return Output(updateViewPublisher: updateViewPublisher,
                      resultCalculatorPublisher: resultCalculatorPublisher)
    }
 ```

## [Implement Calculator Reset](https://github.com/YamamotoDesu/tip-calculator/commit/4cc9f16084f5270e8790c43a3d6ef883fe8bc362)
<img width="300" alt="スクリーンショット 2023-03-27 9 42 08" src="https://user-images.githubusercontent.com/47273077/229331415-49aed139-ff43-4dce-bca5-b2304768997c.gif">

TipInputView.swift
```swift
    func reset() {
        tipSubject.send(.none)
    }
```

SplitInputView.swift
```swift
    func reset() {
        splitSubject.send(1)
    }
```

BillInputView.swift
```swift
    func reset() {
        textField.text = nil
        billSubject.send(0)
    }
```

CalculaterVC.swift
```swift
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
        
        output.resetCalculatorPublisher.sink { [unowned self] _ in
            billInputView.reset()
            tipInputView.reset()
            splitInputView.reset()
            
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                usingSpringWithDamping: 5.0,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut) {
                    self.logoView.transform = .init(scaleX: 1.5, y: 1.5)
                } completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.logoView.transform = .identity
                    }
                }
        }.store(in: &cancellables)
    }
```

### Setup Unit Tests

tip_calculatorTests.swift
```swift
import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorTests: XCTestCase {
    
    private var sut: CalculaterVM!
    private var cancellables: Set<AnyCancellable>!
    
    private let logoViewTapSubject = PassthroughSubject<Void, Never>()

    override func setUp() {
        sut = .init()
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    func testResultWithoutTipFor1Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        // when
        let output = sut.transform(input: input)
        
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculaterVM.Input {
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublichser: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
}
```

### Add More Tests
tip_calculatorTests.swift
```swift
import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorTests: XCTestCase {
    
    private var sut: CalculaterVM!
    private var cancellables: Set<AnyCancellable>!
    
    private let logoViewTapSubject = PassthroughSubject<Void, Never>()

    override func setUp() {
        sut = .init()
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    func testResultWithoutTipFor1Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        // when
        let output = sut.transform(input: input)
        
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWithoutTipFor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        // when
        let output = sut.transform(input: input)
        
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWith10PercentTipFor4Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        // when
        let output = sut.transform(input: input)
        
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 55)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.totalTip, 10)
        }.store(in: &cancellables)
    }
    
    func testResultWithCustomTipTipFor4Person() {
        // given
        let bill: Double = 200.0
        let tip: Tip = .custom(value: 201)
        let split: Int = 4
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        // when
        let output = sut.transform(input: input)
        
        // then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100.25)
            XCTAssertEqual(result.totalBill, 401)
            XCTAssertEqual(result.totalTip, 201)
        }.store(in: &cancellables)
    }
    
    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculaterVM.Input {
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublichser: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
}
```
