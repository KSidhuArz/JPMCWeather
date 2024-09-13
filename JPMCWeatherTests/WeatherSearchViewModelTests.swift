//
//  WeatherSearchViewModelTests.swift
//  WeatherJPMCTests
//
//  Created by Ramandeep Singh on 9/12/24.
//

import XCTest
@testable import JPMCWeather

final class WeatherSearchViewModelTests: XCTestCase {
    var viewModel:WeatherSearchViewModel!
    var mockApi = MockApi(isSuccess: true)
    
    override func setUp() {
        super.setUp()
        viewModel = WeatherSearchViewModel(networkProtocol:mockApi)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchWeatherDetailSuccess() async{
        let expectation = XCTestExpectation(description: "Fetch weather detail successfully")
        do{
            let weatherDetail:Result = try await viewModel.networkProtocol.fetchRequest(url: URLBuilder().setQuery(search: "dallas").build()!, type: Result.self)
            XCTAssertEqual(weatherDetail.name, "Dallas")
        }catch _{
            XCTFail("Fetch data should not fail")
        }
        expectation.fulfill()
    }
    
    func testFetchWeatherDetailFailure() async{
        mockApi.isSuccess = false
        viewModel = WeatherSearchViewModel(networkProtocol:mockApi)
        let expectation = XCTestExpectation(description: "Fetch weather detail successfully")
        do{
            let _:Result = try await viewModel.networkProtocol.fetchRequest(url: URLBuilder().setQuery(search: "dallas").build()!, type: Result.self)
            XCTFail("Fetch data should be fail")
        }catch let error{
            XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (WeatherJPMC.NetworkError error 1.)")
        }
        expectation.fulfill()
    }

}
