//
//  model.swift
//  hackathon-weatherApp
//
//  Created by sehooon on 2022/10/06.
//

import Foundation

protocol WeatherApiDelegate{
    func weahterDataToUI()
}

// [싱글톤 패턴 구현 에정]
class WeatherApi{
    // 싱글톤
    static var singleton = WeatherApi()
    // 델리게이트
    var delegate: WeatherApiDelegate?
    // [QuaryParameter]
    private let apiRequestUrl: String = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
    private let key: String = "보안상 "
    private let dataType:String = "JSON"
    private let numOfRows: String = "290"
    private let pageNo: String = "1"
    private var base_date: String = "20221008"
    private var base_time: String = "2300"
    var nx:String = "60"
    var ny:String = "127"
    
    // [weather_property]
    var tmx = "", tmn = ""
    var nowWeatherData = Wdata()
    
    //[init]
    private init(){}
    
    //[url 생성하기 - 계산속성]
    private var url:String{
        return "\(apiRequestUrl)?serviceKey=\(key)&numOfRows=\(numOfRows)&pageNo=\(pageNo)&base_date=\(base_date)&base_time=\(base_time)&nx=\(nx)&ny=\(ny)&dataType=\(dataType)"
    }
    
    //"전날 23시 기준"으로, 당일 0시부터 24시이전까지의 기상예보 데이터를 수집
    var base_dateSetting: String{
        let nowDate = Date().addingTimeInterval(-86400)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd" // 
        let base_date = dateFormatter.string(from: nowDate) //
        return base_date
    }
    
    // 오늘 날짜 반환
    var nowDate:String{
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시" //
        let base_date = dateFormatter.string(from: nowDate) //
        return base_date
    }
    
    //[생성된 url을 통해, data 요청]
    func requestWeatherData(nx: String, ny: String){
        self.base_time = "2300"
        self.base_date = base_dateSetting
        self.nx = nx
        self.ny = ny
        if let structUrl = URL(string: url){
            let session = URLSession.shared
            session.dataTask(with: structUrl) { [self] data, response, error in
                if let safeData = data{
                    if let weatherArray = parseJSON(safeData){
                        nowWeatherSetting(weatherArray: weatherArray)
                        DispatchQueue.main.async {
                            
                            self.delegate?.weahterDataToUI() }
                    }
                }
            }.resume()
        }
    }
    
    // 날씨 아이콘 출력을 위한 하늘 상태 측정 (오전, 오후, 날씨 상태)
    func skyStatusReturn() -> (Bool, Int){
        let nowTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH" //
        let Hour = dateFormatter.string(from: nowTime)
        var isMorning:Bool = true
        if  Hour >= "17"{ isMorning = false }
        if nowWeatherData.pty! == "0"{
            switch nowWeatherData.sky! {
            case "0"..."5":
                return (isMorning, 0)
            case "6"..."8":
                return (isMorning, 1)
            case "9"..."10":
                return (isMorning, 2)
            default:
               return (isMorning, 0)
            }
        }else{
            let pcp = Double(nowWeatherData.pty!)!
            switch pcp {
            case 0.1..<1.0:
                return (isMorning, 3)
            case 1.0..<30.0:
                return (isMorning, 4)
            default:
                return (isMorning, 5)
            }
        }
        
    }
    // 현재 시간을 기준으로, 받아온 데이터에서 온도 및 데이터 저장
    func nowWeatherSetting(weatherArray:[Item]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let fcstTime = formatter.string(from: Date()) + "00"
        for weather in weatherArray {
            if weather.category == .tmx{ self.tmx = weather.fcstValue }
            if weather.category == .tmn{ self.tmn = weather.fcstValue }
            if fcstTime == weather.fcstTime{
                switch weather.category {
                case .pcp:
                    nowWeatherData.pcp = weather.fcstValue
                case .pop:
                    nowWeatherData.pop = weather.fcstValue
                case .pty:
                    nowWeatherData.pty = weather.fcstValue
                case .reh:
                    nowWeatherData.reh = weather.fcstValue
                case .sky:
                    nowWeatherData.sky = weather.fcstValue
                    print(weather.fcstValue)
                case .sno:
                    nowWeatherData.sno = weather.fcstValue
                case .tmn:
                    nowWeatherData.tmn = weather.fcstValue
                case .tmp:
                    nowWeatherData.tmp = weather.fcstValue
                case .tmx:
                    nowWeatherData.tmx = weather.fcstValue
                case .uuu:
                    nowWeatherData.uuu = weather.fcstValue
                case .vec:
                    nowWeatherData.vec = weather.fcstValue
                case .vvv:
                    nowWeatherData.vvv = weather.fcstValue
                case .wav:
                    nowWeatherData.wav = weather.fcstValue
                case .wsd:
                    nowWeatherData.wsd = weather.fcstValue
                }
            }
        }
    }
}



func parseJSON(_ weatherData: Data) -> [Item]?{
    do{
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(JsonData.self, from: weatherData)
        return decodedData.response.body.items.item
    }catch{
        return nil
    }
    
}




