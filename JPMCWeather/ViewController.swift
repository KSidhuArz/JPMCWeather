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
        // Do any additional setup after loading the view.
        viewModel = WeatherSearchViewModel(networkProtocol: NetworkManager(), delegate: self)
        weatherBgView.isHidden = true
        coreLocationSetup()
        activityIndicatorSetup()
        searchBarCustomize()
    }
    
    func coreLocationSetup(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
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
    
    /// Remove space from string for final url
    /// - Parameter input: we pass city name
    /// - Returns: final string space replace with %20
    func replaceSpaceFromString(input:String) -> String{
        return input.replacingOccurrences(of: " ", with: "%20")
    }
    
}

extension ViewController:WeatherSearchViewModelProtocol{
    func failureResponse(message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.weatherBgView.isHidden = true
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
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
            activityIndicator.startAnimating()
            if searchBar.text != ""{
                Task {
                    await viewModel?.fetchWeatherData(search: replaceSpaceFromString(input: searchBar.text ?? ""))
                }
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

