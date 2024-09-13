//
//  WeatherSearchViewModel.swift
//  WeatherJPMC
//
//  Created by Kulbir Sidhu on 9/11/24.
//
import Foundation

protocol WeatherSearchViewModelProtocol:AnyObject{
    func succesfullResponse()
    func failureResponse(message:String)
}

class WeatherSearchViewModel{
    var networkProtocol:NetworkProtocol
    private var delegate:WeatherSearchViewModelProtocol?
    private var weatherDetail:Result?
    
    init(networkProtocol: NetworkProtocol, delegate: WeatherSearchViewModelProtocol? = nil, weatherDetail: Result? = nil) {
        self.networkProtocol = networkProtocol
        self.delegate = delegate
        self.weatherDetail = weatherDetail
    }

    
    func fetchWeatherData(search:String) async{
        do{
            weatherDetail = try await self.networkProtocol.fetchRequest(url: URLBuilder().setQuery(search: search).build()!, type: Result.self)
            delegate?.succesfullResponse()
        }catch let error{
            print(error.localizedDescription)
            delegate?.failureResponse(message: error.localizedDescription)
        }
    }
    
    //MARK: Display
    
    /// showing wether description
    /// - Returns: string
    func showWeatherDescription() -> String{
        return  weatherDetail?.weather[0].description ?? ""
    }
    
    /// showing weather title
    /// - Returns: string
    func showWeatherTitle() -> String{
        return  weatherDetail?.weather[0].main ?? ""
    }
    
    /// showing weather icon
    /// - Returns: string
    func showWeatherIcon() -> String{
        return weatherDetail?.weather[0].icon ?? "no_Image"
    }
    
    /// showing city name
    /// - Returns: string
    func showCityName() -> String{
        return  weatherDetail?.name ?? ""
    }
}
