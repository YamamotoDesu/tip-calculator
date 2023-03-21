//
//  ThemeFont.swift
//  tip-calculator
//
//  Created by 山本響 on 2023/03/21.
//

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
