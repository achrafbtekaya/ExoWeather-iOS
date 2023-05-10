//
//  ErrorApi.swift
//  ExoWeather
//
//  Created by Achref Ben Tekaya on 9/5/2023.
//

import Foundation

//MARK: Error Management

// Define an enum for handling errors
enum ErrorManagement: Error {
    case decoding // Error when decoding a response from the server
    case server // Error when the server does not respond
    case network // Error when there is a problem with the network connection
    
    // Define a computed property for each error case that returns a description of the error
    var description : String {
        switch self {
        case ErrorManagement.decoding:
            return "Le réponse de serveur n'est pas reconnu" // Description for decoding error
            
        case ErrorManagement.network:
            return "Problème réseau !" // Description for network error
            
        case ErrorManagement.server:
            return "Le serveur ne répond pas" // Description for server error
        }
    }
}

