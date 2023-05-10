//
//  WelcomeViewController.swift
//  ExoWeather
//
//  Created by Achref Ben Tekaya on 9/5/2023.
//

import Foundation
import UIKit

// A view controller to welcome the user to the app
class WelcomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var welcomeLabel: UILabel! // A label to display a welcome message
    @IBOutlet weak var welcomeImage: UIImageView! // An image to display with the welcome message
    @IBOutlet weak var goButton: UIButton! // A button to allow the user to proceed to the main functionality of the app
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor(named: "AccentColor")
        
        // Set up the view
        setUpView()
        
        // Configure the primary button appearance
        setupPrimaryButton(button: goButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up the view
        setUpView()
    }
    
    // MARK: UI Management
    
    // Set up the initial view state
    func setUpView() {
        goButton.isHidden = false
        welcomeLabel.text = "ExoWeather" // Set the welcome message
        goButton.setTitle("Accéder", for: .normal) // Set the text of the button
    }

    // Handle the user pressing the "Go" button
    @IBAction func goToWeather(_ sender: UIButton) {
        // Segue to the main functionality of the app
        self.performSegue(withIdentifier: "WeatherSegue", sender: self)
    }
}
