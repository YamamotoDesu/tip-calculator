//
//  UIResponder+Entention.swift
//  tip-calculator
//
//  Created by 山本響 on 2023/03/27.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
