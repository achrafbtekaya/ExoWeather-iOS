//
//  Extension.swift
//  ExoWeather
//
//  Created by Achref Ben Tekaya on 9/5/2023.
//

import Foundation
import UIKit

// This extension adds a function to UIViewController to style a UIButton as a primary button
extension UIViewController {
    func setupPrimaryButton(button: UIButton) {
        button.layer.cornerRadius = 10 // Set corner radius to 10
        button.layer.shadowColor = UIColor.darkGray.cgColor // Set shadow color to dark gray
        button.backgroundColor = UIColor(named: "AccentColor") // Set background color to an accent color
        button.setTitleColor(.white, for: .normal) // Set text color to white
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0) // Set shadow offset to (2,2)
        button.layer.shadowOpacity = 0.4 // Set shadow opacity to 0.4
        button.layer.shadowRadius = 3.0 // Set shadow radius to 3.0
    }
}

// This extension adds a computed property to String to capitalize the first letter of the string
extension String {
    var capitalizeFirstLetter: String {
        return self.prefix(1).capitalized + dropFirst() // Get the first character, capitalize it, and append the rest of the string
    }
}
