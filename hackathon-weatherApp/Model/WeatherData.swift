import Foundation

// MARK: - Welcome
struct JsonData: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let baseDate, baseTime: String
    let category: Category
    let fcstDate, fcstTime, fcstValue: String
    let nx, ny: Int
}

enum Category: String, Codable {
    // 1시간 강수량
    case pcp = "PCP"
    // 강수확률
    case pop = "POP"
    // 강수형태
    case pty = "PTY"
    // 습도
    case reh = "REH"
    // 하늘상태
    case sky = "SKY"
    // 1시간 신적설
    case sno = "SNO"
    // 일 최저기온
    case tmn = "TMN"
    // 1시간 기온
    case tmp = "TMP"
    // 일 최고기온
    case tmx = "TMX"
    // 풍속(동서성분)
    case uuu = "UUU"
    // 풍향
    case vec = "VEC"
    // 풍속(남북성분)
    case vvv = "VVV"
    // 파고
    case wav = "WAV"
    // 풍속
    case wsd = "WSD"
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}


//
struct Wdata{
    //   (True/False, Value)
    var pcp:String?
    var pop:String? 
    var pty:String? 
    var reh:String? 
    var sky:String? 
    var sno:String? 
    var tmn:String? 
    var tmp:String?
    var tmx:String?
    var uuu:String? 
    var vec:String? 
    var vvv:String? 
    var wav:String? 
    var wsd:String? 
}

