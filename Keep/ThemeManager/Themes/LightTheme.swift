//
//  LightTheme.swift
//  Keep
//
//  Created by admin on 22.11.2025.
//

import UIKit

struct LightTheme: Theme {
    let gradientColors: [CGColor] = [
        UIColor(red: 0.75, green: 0.72, blue: 1.0, alpha: 1.0).cgColor,
        UIColor(red: 1.0, green: 0.72, blue: 0.75, alpha: 1.0).cgColor,
        UIColor(red: 1.0, green: 0.76, blue: 0.7, alpha: 1.0).cgColor
    ]
    
    let gradientLocations: [NSNumber] = [0.0, 0.2, 1.0]
    let gradientStartPoint = CGPoint(x: 0.0, y: 1.0)
    let gradientEndPoint = CGPoint(x: 2.0, y: 0.2)
    let blurStyle: UIBlurEffect.Style = .systemUltraThinMaterialLight
    let tintColor = UIColor.ypWhite.withAlphaComponent(0.2)
    let glassBorderColor: CGColor? = UIColor.ypDarkGray.cgColor
    let glassBorderWidth: CGFloat = 0.2
    let userInterfaceStyle: UIUserInterfaceStyle = .light
}
