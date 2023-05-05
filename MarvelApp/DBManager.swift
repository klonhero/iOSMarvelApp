import RealmSwift

@objcMembers
class CharacterModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var imageUrl: String
    @Persisted var descriptions: String
    
    convenience init(id: Int, name:String, imageUrl: String, description: String) {
        self.init()
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.descriptions = description
    }
}

protocol CharacterDataBaseManager: AnyObject{
    func saveCharacter(_ character: CharacterModel)
    func getCharacters() -> [CharacterModel]
    func getCharacter(by id: Int) -> CharacterModel?
}

final class DataBaseManagerImpl {
    private let realm = try? Realm()
    
    private func add<T: Object>(_ object: T) {
        try? realm?.write {
            realm?.add(object, update: .modified)
        }
    }
    
    private func get<T: Object>(by id: Int) -> T? {
        guard let object = realm?.object(ofType: T.self, forPrimaryKey: id) else {
            return nil
        }
        return object
    }
    
    private func getAll<T: Object>() -> [T] {
        guard let objects = realm?.objects(T.self) else {
            return []
        }
        return Array(objects)
    }
}

extension DataBaseManagerImpl: CharacterDataBaseManager {
    
    func saveCharacter(_ character: CharacterModel) {
        add(character)
    }
    
    func getCharacters() -> [CharacterModel] {
        return getAll()
    }
    
    func getCharacter(by id: Int) -> CharacterModel? {
        return get(by: id)
    }
}
