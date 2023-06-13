//
//  WeatherManager.swift
//  Clima
//
//  Created by Orlando Moraes Martins on 13/06/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL  = "https://api.openweathermap.org/data/2.5/weather?appid=ecce665c459c1531208ad1a7e82a52c2&units=metric"
    
    func fetchWeather(cityName: String) {
        let cityString = cityName.replacingOccurrences(of: " ", with: "%")
        print(cityString)
        let urlString = "\(weatherURL)&q=\(cityString)"
        performRequest(urlString: urlString)
    }
    
    func performRequest (urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString){
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            
            //4. Start the task
            task.resume()
        }
    }
    
    func handle (data: Data?, response: URLResponse?, error: Error?){
        if error != nil  {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
        
    }
}
