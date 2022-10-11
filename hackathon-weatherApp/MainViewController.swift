//
//  ViewController.swift
//  hackathon-weatherApp
//
//  Created by sehooon on 2022/10/05.
//
import UIKit
import CoreLocation


@available(iOS 14.0, *)
class MainViewController: UIViewController{
    var dataKey:String?
    var locationDB = LocationDB()
    let weatherAPI = WeatherApi.singleton
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    let nightWeatherImageArr:[UIImage] = [#imageLiteral(resourceName: "Image-9"),#imageLiteral(resourceName: "Image-10"),#imageLiteral(resourceName: "Image-3"), #imageLiteral(resourceName: "Image-4"), #imageLiteral(resourceName: "Image-5"), #imageLiteral(resourceName: "Image-6")]
    let morningWeatherImageArr:[UIImage] = [#imageLiteral(resourceName: "Image-1"),#imageLiteral(resourceName: "Image-2"), #imageLiteral(resourceName: "Image-3"), #imageLiteral(resourceName: "Image-4"), #imageLiteral(resourceName: "Image-5"), #imageLiteral(resourceName: "Image-6")]
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tmxLabel: UILabel!
    @IBOutlet weak var tmnLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDB.LocationInfoFromCSV()
        weatherAPI.delegate = self
        locationManager.delegate = self
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "locationSearchVC") as? LocationTableViewController else{ return }
        present(searchVC, animated: true, completion: nil)
        searchVC.dataSendClosure = { [self] data in
            dataKey = locationDB.returnCityName(data)
        }
    }
}

// UISetup()
extension MainViewController: WeatherApiDelegate{
    func weahterDataToUI()
    {
        if dataKey != nil{
            self.locationNameLabel.text = dataKey!
            dataKey = nil
        }else{
            self.locationNameLabel.text = locationDB.returnCityName(weatherAPI.nx, weatherAPI.ny)
        }
        
        self.temperatureLabel.text = weatherAPI.nowWeatherData.tmp! + "℃"
        self.dateLabel.text = weatherAPI.nowDate + "기준"
        self.humidityLabel.text = weatherAPI.nowWeatherData.reh! + "%"
        self.tmxLabel.text = weatherAPI.tmx + "℃"
        self.tmnLabel.text = weatherAPI.tmn + "℃"
        if weatherAPI.skyStatusReturn().0 == true{
            self.weatherIcon.image = morningWeatherImageArr[weatherAPI.skyStatusReturn().1]
        }else{
            self.weatherIcon.image = nightWeatherImageArr[weatherAPI.skyStatusReturn().1]
        }
    }
}

extension MainViewController: CLLocationManagerDelegate{
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            let position = convertGRID_GPS(mode: 0, lat_X: lat, lng_Y: lon)
            weatherAPI.requestWeatherData(nx: String(position.x), ny: String(position.y))
            manager.stopUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { print(error) }
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        //위치 사용을 허용한 경우, 로케이션 위치정보 받아오기.
        case .authorizedAlways, .authorizedWhenInUse:
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            manager.startUpdatingLocation()
        //위치 사용 권한을 거부한 경우, 기본 디폴트 값.
        case .denied:
            manager.requestWhenInUseAuthorization()
            let weatherAPI = WeatherApi.singleton
            weatherAPI.requestWeatherData(nx: "60", ny: "127")
        case .restricted:
            manager.requestWhenInUseAuthorization()
            print("res")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            print("notDeter")
        default:
            manager.requestWhenInUseAuthorization()
        }
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
    }
    
        
    
}




