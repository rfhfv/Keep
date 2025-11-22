//
//  UIView+Extensions.swift
//  Keep
//
//  Created by admin on 20.11.2025.
//

import UIKit

extension UIView {
    func applyThemeBackgroundGradient() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradient = ThemeManager.shared.backgroundGradient()
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGlassEffect(cornerRadius: CGFloat = Constants.Layout.cornerRadius) -> UIVisualEffectView {
        subviews.filter { $0 is UIVisualEffectView }.forEach { $0.removeFromSuperview() }
        
        let glassView = ThemeManager.shared.glassEffect()
        glassView.layer.cornerRadius = cornerRadius
        glassView.layer.masksToBounds = true
        
        let borderColor = ThemeManager.shared.glassBorderColor()
        let borderWidth = ThemeManager.shared.glassBorderWidth()
        
        glassView.layer.borderWidth = borderWidth
        glassView.layer.borderColor = borderColor
        
        let currentTheme = ThemeManager.shared.currentTheme
        if currentTheme == .light {
            glassView.layer.shadowColor = UIColor.ypBlack.withAlphaComponent(0.1).cgColor
            glassView.layer.shadowOffset = CGSize(width: 0, height: 1)
            glassView.layer.shadowRadius = 3
            glassView.layer.shadowOpacity = 0.5
        } else {
            glassView.layer.shadowColor = UIColor.ypBlack.withAlphaComponent(0.3).cgColor
            glassView.layer.shadowOffset = CGSize(width: 0, height: 2)
            glassView.layer.shadowRadius = 4
            glassView.layer.shadowOpacity = 0.6
        }
        
        glassView.frame = bounds
        glassView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(glassView, at: 0)
        
        return glassView
    }
    
    func updateGradientOnThemeChange() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ThemeDidChange"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.applyThemeBackgroundGradient()
        }
    }
}
