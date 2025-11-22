//
//  UILabel+Extensions.swift
//  Keep
//
//  Created by admin on 13.11.2025.
//

import UIKit

extension UILabel {
    func configureLabel(
        text: String? = nil,
        font: UIFont,
        alignment: NSTextAlignment = .center,
        numberOfLines: Int = 0,
        textColor: UIColor? = nil
    ) {
        self.text = text
        self.font = font
        self.textAlignment = alignment
        self.numberOfLines = numberOfLines
        self.textColor = textColor
    }
}
