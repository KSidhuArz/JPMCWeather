import UIKit
import CoreLocation

class ViewController: UIViewController  {
    private var viewModel:WeatherSearchViewModel?
    private var locationManager: CLLocationManager?
    private var locationEnable: Bool = false
    @IBOutlet weak var weatherBgView: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var weatherConditionLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Intializing view model
        viewModel = WeatherSearchViewModel(networkProtocol: NetworkManager(), delegate: self)
        
        /*checking if user did last search then showing last search city/country/zipp code autofilled*/
        if let lastSearch = UserDefaults.standard.value(forKey: "lastSearch") as? String {
            searchBar.text = lastSearch
            fetchWeatherDetail()
        }
        
        weatherBgView.isHidden = true
        coreLocationSetup()
        activityIndicatorSetup()
        searchBarCustomize()
    }
    
    ///location manager for access user location
    func coreLocationSetup(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    ///Set up for activity indicator
    func activityIndicatorSetup(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func searchBarCustomize(){
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        if #available(iOS 13.0, *) {
                 searchBar.searchTextField.delegate = self
              }
    }
    
    func fetchWeatherDetail(){
        activityIndicator.startAnimating()
        Task {
            await viewModel?.fetchWeatherData(search: replaceSpaceFromString(input: searchBar.text ?? ""))
        }
    }
    
    /// Remove space from string for final url
    /// - Parameter input: we pass city name
    /// - Returns: final string space replace with %20
    func replaceSpaceFromString(input:String) -> String{
        return input.replacingOccurrences(of: " ", with: "%20")
    }
    
}

extension ViewController:WeatherSearchViewModelProtocol{
    /// handling error case
    /// - Parameter message: getting error message
    func failureResponse(message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.weatherBgView.isHidden = true
            let alert = UIAlertController(title: "", message: "City not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func succesfullResponse() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.weatherBgView.isHidden = false
            self.weatherConditionLbl.text = self.viewModel?.showWeatherTitle()
            self.descriptionLbl.text = self.viewModel?.showWeatherDescription()
            self.cityNameLbl.text = self.viewModel?.showCityName()
        }
        DispatchQueue.global().async {
            if let url = URL(string: String(format: "%@%@@2x.png", "https://openweathermap.org/img/wn/",self.viewModel?.showWeatherIcon() ?? "")){
                self.weatherIcon.loadImage(from: url, placeholder: UIImage(named: "no_Image"))
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate{
    /*checking if user location is on or off based on that setting bool value*/
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            locationEnable = true
            break
        case .restricted, .denied:
            locationEnable = false
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if locationEnable == true {
            if searchBar.text != ""{
                UserDefaults.standard.setValue(searchBar.text, forKey: "lastSearch")
                fetchWeatherDetail()
            }
        } else {
            self.weatherBgView.isHidden = true
            let alert = UIAlertController(title: "Weather App", message: "Please turn on your location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.addAction(UIAlertAction.init(title: "Setting", style: .default, handler: { something in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            present(alert, animated: true)
        }
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Canceled    sssss")
    }
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
            // your code
        self.weatherBgView.isHidden = true
            return true
        }
}

