//
//  WeatherManager.swift
//  Clima
//
//  Created by Orlando Moraes Martins on 13/06/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithErrot( error: Error)
}

struct WeatherManager {
    let weatherURL  = "https://api.openweathermap.org/data/2.5/weather?appid=ecce665c459c1531208ad1a7e82a52c2&units=metric"

    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let cityString = cityName.replacingOccurrences(of: " ", with: "%")
        print(cityString)
        let urlString = "\(weatherURL)&q=\(cityString)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString){
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil  {
                    self.delegate?.didFailWithErrot(error: error)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJson(weatherData: safeData) {
                        self.delegate?.didUpdateWeather( self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithErrot(error: error)
            return nil
        }
    }
    
}
