import Alamofire
import RealmSwift

final class CharactersCollectionViewModel {
    private let base_url = "https://gateway.marvel.com"
    private let heroes_endpoint = "/v1/public/characters"
    private var offset = 0
    
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

    func fetchHeroes(compleation: @escaping ([CharactersCollectionViewController.Model], Int) -> Void, failed: @escaping () -> Void ) {
        let authParams = ["ts": "123", "apikey": "42597bee717ef2847e9b63553f4aff0f", "hash": "f49ba2754d66300142cf36b108860d2c", "offset": offset] as [String : Any]
        var heroesData: [CharactersCollectionViewController.Model] = []
        AF.request(base_url + heroes_endpoint, method: .get, parameters: authParams)
        .responseDecodable(of: CharacterDataWrapper.self) { response in
            switch response.result {
            case .success(_): {
                guard
                    let dataWrapper = response.value,
                    let data = dataWrapper.data,
                    let results = data.results
                else {
                    return
                }
                for character in results {
                    heroesData.append(CharactersCollectionViewController.Model(name: character.name, description: character.description, imageURL: character.thumbnail.path + "." + character.thumbnail.ext))
                }
                compleation(heroesData, self.offset)
                self.offset += heroesData.count
            }()
            case .failure(_):
                failed()
            }
        }
    }
}

