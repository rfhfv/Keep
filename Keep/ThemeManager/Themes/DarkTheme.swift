//
//  DarkTheme.swift
//  Keep
//
//  Created by admin on 22.11.2025.
//

import UIKit

struct DarkTheme: Theme {
    let gradientColors: [CGColor] = [
        UIColor(red: 0.4, green: 0.3, blue: 0.5, alpha: 1.2).cgColor,
        UIColor(red: 0.2, green: 0.3, blue: 0.45, alpha: 1.2).cgColor,
        UIColor(red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0).cgColor
    ]
    
    let gradientLocations: [NSNumber] = [0.0, 0.1, 0.4]
    let gradientStartPoint = CGPoint(x: 0.0, y: 1.0)
    let gradientEndPoint = CGPoint(x: 2.0, y: 0.2)
    let blurStyle: UIBlurEffect.Style = .systemUltraThinMaterialDark
    let tintColor = UIColor.ypBlack.withAlphaComponent(0.15)
    let glassBorderColor: CGColor? = UIColor.ypWhite.withAlphaComponent(0.3).cgColor
    let glassBorderWidth: CGFloat = 0.2
    let userInterfaceStyle: UIUserInterfaceStyle = .dark
}
