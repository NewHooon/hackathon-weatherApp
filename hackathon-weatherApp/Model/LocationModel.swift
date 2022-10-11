
import Foundation
//"서울특별시","종로구","청운효자동","60","127"
struct LocationModel{
    var dataKey: String = ""
    var firstDivision: String = ""
    var secondDivision: String = ""
    var thirdDivision: String = ""
    var nx: String = ""
    var ny: String = ""
}

class LocationDB{
    var locationDataArr:[LocationModel] = []
    static var singleton = LocationDB()
    
    func returnCityName(_ nx:String, _ ny : String) -> String{
        if !locationDataArr.isEmpty{
            for location in locationDataArr{
                if location.nx == nx && location.ny == ny {
                    return location.firstDivision + " " + location.secondDivision + " " + location.thirdDivision
                }
            }
        }
        return ""
    }
    
    func returnCityName(_ dataKey: String) -> String{
        if !locationDataArr.isEmpty{
            for location in locationDataArr{
                if location.dataKey == dataKey{
                    return location.firstDivision + " " + location.secondDivision + " " + location.thirdDivision
                }
            }
        }
        return ""
    }
    
    private func parseCSV(url: URL) {
           do {// url을 받은 data
               let data = try Data(contentsOf: url)
               // 해당 data를 encoding 합니다.
               let dataEncoded = String(data: data, encoding: .utf8)
               if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArr[0...dataArr.count - 2]{
                    var location = LocationModel()
                    location.dataKey = item[0]
                    location.firstDivision = item[1]
                    location.secondDivision = item[2]
                    location.thirdDivision = item[3]
                    location.nx = item[4]
                    location.ny = item[5]
                    locationDataArr.append(location)
                }
               }
           } catch {
               print("Error reading CSV file")
           }
       }

    func LocationInfoFromCSV() {
        let path = Bundle.main.path(forResource: "LocationDataBase", ofType: "csv")!
        parseCSV(url: URL(fileURLWithPath: path))
    }
}


