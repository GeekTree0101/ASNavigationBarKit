import Foundation
import Codextended

struct Gmail: Codable {
    
    var username: String = ""
    var title: String = ""
    var content: String = ""
    
    init(from decoder: Decoder) throws {
        username = try! decoder.decode("username")
        title = try! decoder.decode("title")
        content = try! decoder.decode("content")
    }
    
}

