//
//  Webservice.swift
//  Authentication3
//
//  Created by Tomislav Zvonarek on 28.04.2023..
//

import Foundation

//enum for handling authentication errors
enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

//struct to decode JSON response from uthentication API
struct LoginResponse: Codable {
    let username: String
    let accessToken: String
}

//func that handles authenticaiton process by making a POST request to the authentication API with email and password provided by user
func authenticate(email: String, password: String, completion: @escaping (Result<LoginResponse, AuthenticationError>) -> Void) {
    
    
    let appId = //your app id
    guard let url = URL(string: /* service url*/) else {
        completion(.failure(.custom(errorMessage: "URL is not correct")))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    //dictionary containing appId, email and password
    let body = [
        "appId": appId,
        "email": email,
        "password": password
    ]
    
    guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
        completion(.failure(.invalidCredentials))
        return
    }
    request.httpBody = bodyData
    
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        DispatchQueue.main.async {
            completion(.success(loginResponse))
            print("JWT token: \(loginResponse.accessToken)")
        }
    }
    .resume()
}

//func used to load user data after recieving valid JWT access token
func loadData(accessToken: String, completion: @escaping (Result<User, AuthenticationError>) -> Void) {
    guard let url = URL(string: /* service url*/) else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(AuthenticationError.custom(errorMessage: "Failed to fetch user data")))
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }.resume()
}
