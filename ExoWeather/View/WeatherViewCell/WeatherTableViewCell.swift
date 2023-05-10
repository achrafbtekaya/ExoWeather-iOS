//
//  WeatherTableViewCell.swift
//  ExoWeather
//
//  Created by Achref Ben Tekaya on 9/5/2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    // Outlets for the labels and image view in the cell
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // Called when the cell is loaded from the xib or storyboard file
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Called when the cell is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set the weather data for the cell
    var weatherSet: WeatherResponse? {
        didSet {
            // Set the city label to the name of the city
            cityLabel.text = weatherSet?.name
            
            // Set the temperature label to the current temperature in Celsius
            tempLabel.text = "\(Int(weatherSet?.main.temp ?? 0))°C"
            
            // Set the condition label to the description of the current weather
            // and capitalize the first letter of the description
            conditionLabel.text = weatherSet?.weather.first?.description.capitalizeFirstLetter ?? "Inconnu"
            
            // Set the image view to the icon that represents the current weather
            weatherIcon.image = UIImage(named: weatherSet?.weather.first?.icon ?? "02d")
        }
    }
}
