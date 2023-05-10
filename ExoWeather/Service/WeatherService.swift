//
//  NetworkRequests.swift
//  ExoWeather
//
//  Created by Achref Ben Tekaya on 9/5/2023.
//

import Foundation
import Alamofire

class NetworkRequests {
    func getWeatherByCity (cityName: String , completion: @escaping (Result<WeatherResponse?, ErrorManagement>) -> Void) {
        
        let parameters: Parameters = self.buildParameters(cityName: cityName)
        
        guard let url = URL(string: Constants.BEGIN_URL) else {
            completion(.failure(.server))
            return
        }

        Alamofire.request(url, parameters: parameters).responseJSON { response in
            // Server Error
            guard let data = response.data, response.error == nil else {
                completion(.failure(.server))
                return
            }
            
            // Network Error
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.network))
                return
            }

            // JSON Parse Error
            guard let reponseJson = response.result.value as? Dictionary<String, AnyObject> else {
                completion(.failure(.decoding))
                return
            }
            
            // Success Response
            let currentWeather: WeatherResponse = reponseJson
            completion(.success(currentWeather))
        }
    }
    
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
