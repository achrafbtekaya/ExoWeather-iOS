//
//  WeatherDetailsViewController.swift
//  ExoWeather
//
//  Created by Achref Ben Tekaya on 9/5/2023.
//


import Foundation
import UIKit
import SwiftyGif

class WeatherDetailsViewController: UIViewController {
    
    //MARK: UI Vars
    @IBOutlet private weak var loadingTextLabel: UILabel!
    @IBOutlet private weak var weatherTableview: UITableView!

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressPercentLabel: UILabel!

    //MARK: BL Vars
    var loadingMessages = ["Nous téléchargeons les données…", "C’est presque fini…", "Plus que quelques secondes avant d’avoir le résultat…"]
    var cities = ["Rennes", "Paris", "Nantes", "Bordeaux", "Lyon"]
    // variables to store the loading messages, cities and the weather data
    var weatherArray = [WeatherResponse]()
    var loadProgressTimer: Timer?
    var msgChangesTimer: Timer?
    var fetchAPITimer: Timer?
    // variables to handle timers for loading progress, message changes and API calls

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableview.delegate = self
        weatherTableview.dataSource = self
        setupCell()
        // set the delegate and datasource for the tableview and call setupCell function
        
        setUpLoadingView()
        setupPrimaryButton(button: restartButton)
        // setup the loading view and primary button, and set the navigation bar tint color
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        msgChangesTimer?.invalidate()
        fetchAPITimer?.invalidate()
        loadProgressTimer?.invalidate()
    }

    //MARK: UI Management
    func setUpLoadingView() {
        progressBar.progress = 0.0
        progressPercentLabel.text = "0%"
        progressBar.isHidden = false
        progressPercentLabel.isHidden = false
        
        weatherImage.isHidden = false
        do {
            let gif = try UIImage(gifName: "WeatherLoading.gif")
            self.weatherImage.setGifImage(gif, loopCount: -1) // Will loop forever
        } catch {
            print(error)
        }
        // setup the progress bar, percentage label, and weather image with a looping gif
        
        restartButton.isHidden = true
        restartButton.titleLabel?.text = "Recommencer"
        weatherTableview.isHidden = true
        
        loadingTextLabel.isHidden = false
        loadingTextLabel.text = self.loadingMessages[0]
        startLoadingView()
        // hide the restart button, tableview and set the initial loading message and start the loading view
    }

    func setUpWeatherView() {
        msgChangesTimer?.invalidate()
        fetchAPITimer?.invalidate()

        loadingTextLabel.isHidden = true
        progressBar.isHidden = true
        progressPercentLabel.isHidden = true
        weatherImage.isHidden = true

        restartButton.isHidden = false
        weatherTableview.isHidden = false
        
        weatherTableview.reloadData()
        // show the restart button and tableview, and hide the loading UI elements. Reload the tableview data.
    }

    @IBAction func restartLoading(_ sender: UIButton) {
        setUpLoadingView()
        // restart the loading process by calling setUpLoadingView function
    }
    //MARK: Table View Management
    func setupCell() {
        // Registers a Nib file for the "WeatherViewCell" cell in the weatherTableview
        let nibName = UINib(nibName: "WeatherViewCell", bundle: nil)
        weatherTableview.register(nibName, forCellReuseIdentifier: "weatherCell")
    }

    //MARK: Loading View Management
    func startLoadingView() {
        // Updates the loading message label, the progress bar and starts the API call timer
        updateLabelMsg()
        updateProgressBar()
        launchCallAPI()
    }

    func updateLabelMsg() {
        var index = 1
        // Sets up a timer that changes the loading message label every 6 seconds
        msgChangesTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: { (timer) in
            self.loadingTextLabel.text = self.loadingMessages[index]
            index += 1
            if index == 3 {
                index = 0
            }
        })
    }

    func updateProgressBar() {
        var progress: Float = 0.0
        
        // Displays the progress bar and sets its initial progress to 0
        progressBar.isHidden = false
        progressBar.progress = progress
        
        // Sets up a timer that updates the progress bar every 0.6 seconds
        loadProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true, block: { [self] (timer) in
            progress += 0.01
            self.progressBar.progress = progress
            progressPercentLabel.text = "\(Int(round(progress*100)))%"

            // Stops the timer when the progress bar reaches 100%
            if self.progressBar.progress == 1.0 {
               self.loadProgressTimer?.invalidate()
            }
        })
    }

    //MARK: API Call Management
    func launchCallAPI() {
        var index = 0

        // Sets up a timer that calls the fetchWeathers function every 10 seconds
        fetchAPITimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { timer in
            self.fetchWeathers(index: index)
            index += 1
        })
    }

    func fetchWeathers(index: Int) {
        // If all cities have been fetched, sets up the weather view and stops the API call timer
        if index >= cities.count {
            setUpWeatherView()
            return
        }
        
        // Fetches the weather data for the current city and appends it to the weatherArray
        let city = cities[index]
        let weatherService = WeatherService()
        weatherService.getWeatherByCity(cityName: city) { result in
            switch result {
            case .success(let weatherInfo):
                if let weather = weatherInfo {
                    self.weatherArray.append(weather)
                }
            case .failure(let error):
                // Displays an alert if there is an error with the server
                self.alertServerAccess(error: error.description)
            }
        }
    }

    func alertServerAccess(error: String) {
        // Displays an alert with the error message
        let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension WeatherDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell from the table view
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else {
            // If the cell could not be dequeued, return an empty cell
            return UITableViewCell()
        }
        
        // Get the weather information for the city at the current index path
        let cityWeather = weatherArray[indexPath.row]
        // Configure the weather cell with the city's weather information
        weatherCell.weatherSet = cityWeather
        
        // Return the configured weather cell
        return weatherCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return CGFloat(150)
   }
}
