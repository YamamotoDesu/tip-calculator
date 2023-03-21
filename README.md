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
