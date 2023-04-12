import Alamofire


final class HeroListViewModel {
    private let base_url = "https://gateway.marvel.com"
    private let heroes_endpoint = "/v1/public/characters"
    private let authParams = ["ts": "123", "apikey": "42597bee717ef2847e9b63553f4aff0f", "hash": "f49ba2754d66300142cf36b108860d2c"]
    
    private struct CharacterDataWrapper: Decodable {
        var code: Int
        var status: String
        var data: CharacterDataContainer?
        
        enum CodingKeys: String, CodingKey {
            case code = "code"
            case status = "status"
            case data = "data"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
     
            code = try values.decode(Int.self, forKey: .code)
            status = try values.decode(String.self, forKey: .status)
            data = try values.decode(CharacterDataContainer.self, forKey: .data)
        }
    }

    private struct CharacterDataContainer: Decodable {
        var offset: Int
        var limit: Int
        var total: Int
        var count: Int
        var results: [Character]?

        enum CodingKeys: String, CodingKey {
            case offset = "offset"
            case limit = "limit"
            case total = "total"
            case count = "count"
            case results = "results"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
     
            offset = try values.decode(Int.self, forKey: .offset)
            limit = try values.decode(Int.self, forKey: .limit)
            total = try values.decode(Int.self, forKey: .total)
            count = try values.decode(Int.self, forKey: .count)
            results = try values.decode([Character].self, forKey: .results)
        }
    }

    private struct Character: Decodable {
        var id: Int
        var name: String
        var description: String
        var thumbnail: Thumbnail

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case description = "description"
            case thumbnail = "thumbnail"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
     
            id = try values.decode(Int.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            description = try values.decode(String.self, forKey: .description)
            thumbnail = try values.decode(Thumbnail.self, forKey: .thumbnail)
        }
    }

    private struct Thumbnail: Decodable {
        var path: String
        var ext: String //extension
        enum CodingKeys: String, CodingKey {
            case path = "path"
            case ext = "extension"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            path = try values.decode(String.self, forKey: .path)
            ext = try values.decode(String.self, forKey: .ext)
        }
    }

    func fetchHeroes(compleation: @escaping ([HeroData]) -> Void) {
        AF.request(base_url + heroes_endpoint, method: .get, parameters: authParams)
            .responseDecodable(of: CharacterDataWrapper.self) { (response) in
            guard
                let dataWrapper = response.value,
                let data = dataWrapper.data,
                let results = data.results
            else {
                return
            }
                for character in results {
                    self.heroesData.append(HeroData(name: character.name, description: character.description, imageURL: character.thumbnail.path + "." + character.thumbnail.ext))
                }
                
            print(self.heroesData)
            compleation(self.heroesData)
        }
    }
    private var heroesData: [HeroData] = []
    
//    private let listHeroData: [HeroData] = [
//        HeroData(asset: "CaptainAmerica", name: "Captain America", color: "CaptainAmerica", description: "This is Captain America", url: "https://freepngimg.com/thumb/captain_america/7-2-captain-america-png-hd.png"),
//        HeroData(asset: "IronMan", name: "Iron Man", color: "IronMan", description: "This is Iron Man", url: "https://i.pinimg.com/originals/c1/4a/9f/c14a9f2295038c162b7b076c28c06af7.png"),
//        HeroData(asset: "Deadpool", name: "Deadpool", color: "Deadpool", description: "This is Deadpool", url: "https://www.pngall.com/wp-content/uploads/2016/03/Deadpool-PNG.png"),
//        HeroData(asset: "DoctorStrange", name: "Doctor Strange", color: "DoctorStrange", description: "This is Doctor Strange", url: "https://www.pngall.com/wp-content/uploads/11/Marvel-Doctor-Strange.png"),
//        HeroData(asset: "Thor", name: "Thor", color: "Thor", description: "This is Thor weqwdsacasdasdwqe weqwdqwuhewiufhuyewgvyuiewqgyfgqewyucgeuwyqcgewqgcuyewgqcyugq equwygcyuegwqycugewyqucgequwycyueqwgcyugwyuegwquycgequwycgyequwcuegqwycugequwycguyeqwe13kdlajioduasud21u3poj12j oidhiuo1 youdyo1ihdio h12oi hdio12 hdh2io1 hdoh12jiu atdy g1iuk hj12hi hu1 khu2i1 12hiu hsaud 13", url: "https://i.pinimg.com/originals/fc/31/85/fc318551acc519108d011018a0a33421.png")]
}
