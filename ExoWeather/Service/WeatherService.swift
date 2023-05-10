//
//  WeatherService.swift
//  ExoWeather
//
//  Created by Achref Ben Tekaya on 9/5/2023.
//

import Foundation
import Alamofire

// This class is used to make API requests to get weather data for a given city
class WeatherService {
    
    // This function takes a city name and a completion handler as input
    // The completion handler returns a Result type with either a WeatherResponse or an ErrorManagement
    func getWeatherByCity(cityName: String, completion: @escaping (Result<WeatherResponse?, ErrorManagement>) -> Void) {
        
        // Build parameters for the API request
        let parameters: Parameters = self.buildParameters(cityName: cityName)
        
        // Check if the URL is valid
        guard let url = URL(string: Constants.BEGIN_URL) else {
            completion(.failure(.server)) // If URL is not valid, return a server error
            return
        }

        // Make an API request using Alamofire
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            // Check if there is an error while receiving data from the server
            guard let data = response.data, response.error == nil else {
                completion(.failure(.server)) // If there is an error, return a server error
                return
            }
            
            // Check if there is a network error (e.g. status code is not 200)
            guard let httpResponse = response.response, httpResponse.statusCode == 200 else {
                completion(.failure(.network)) // If there is a network error, return a network error
                return
            }

            // Parse the JSON response and decode it into a WeatherResponse object
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(result)) // If successful, return a WeatherResponse object
            } catch {
                completion(.failure(.decoding)) // If there is a parsing error, return a decoding error
            }
        }
    }
    
    // This function builds the parameters needed for the API request
    private func buildParameters(cityName: String) -> Parameters {
        let parameters: Parameters = [
            "appid": Constants.API_KEY,
            "units": "metric",
            "lang": "fr",
            "q": String(cityName)
        ]
        
        return parameters
    }
}
